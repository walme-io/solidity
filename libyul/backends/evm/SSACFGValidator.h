/*
	This file is part of solidity.

	solidity is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	solidity is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with solidity.  If not, see <http://www.gnu.org/licenses/>.
*/
// SPDX-License-Identifier: GPL-3.0

#pragma once

#include <libyul/backends/evm/ControlFlow.h>
#include <libyul/backends/evm/SSAControlFlowGraph.h>

namespace solidity::yul
{
class SSACFGValidator
{
public:
	static void validate(ControlFlow const& _controlFlow, Block const& _ast, AsmAnalysisInfo const& _analysisInfo, Dialect const& _dialect);
private:
	struct Context {
    	AsmAnalysisInfo const& analysisInfo;
	    Dialect const& dialect;
    	ControlFlow const& controlFlow;
    	SSACFG const& cfg;
    };
	class VariableMapping
	{
	public:
		using VarToValueIds = std::map<Scope::Variable const*, std::set<SSACFG::ValueId>>;
		using ValueIdToVars = std::vector<std::set<Scope::Variable const*>>;
		using PhiMap = std::map<SSACFG::ValueId, std::set<SSACFG::ValueId>>;

		explicit VariableMapping(size_t const numValueIds): m_valueIdToVars(numValueIds) {}
		VariableMapping(VariableMapping const&) = default;
		VariableMapping& operator=(VariableMapping const&) = default;
		~VariableMapping() = default;

		void defineVariable(Scope::Variable const& _var, std::set<SSACFG::ValueId> const& _values)
		{
			update({&_var}, _values, false);
		}
		bool contains(Scope::Variable const& _var) const { return m_varToValueIds.count(&_var) > 0; }
		bool contains(SSACFG::ValueId const& _valueId) const
		{
			return _valueId.value < m_valueIdToVars.size() && !m_valueIdToVars[_valueId.value].empty();
		}
		void set(Scope::Variable const& _variable, std::set<SSACFG::ValueId> const& _values)
		{
			update({&_variable}, _values, false);
		}
		void addValues(Scope::Variable const& _variable, std::set<SSACFG::ValueId> const& _values)
		{
			update({&_variable}, _values, true);
		}
		void merge(VariableMapping const& _variables) { merge(std::vector{_variables}); }
		void merge(std::vector<VariableMapping> const& _variables)
		{
			for (auto const& [var, valueIds]: m_varToValueIds)
			{
				yulAssert(var);
				for (auto const& otherMapping: _variables)
				{
					if (auto it = otherMapping.m_varToValueIds.find(var); it != otherMapping.m_varToValueIds.end())
					{
						update({var}, it->second, true);
					}
				}
			}
		}
		void applyPhiMap(PhiMap const& _phiMap)
		{
			for (auto const& [argValueId, phiValueIds]: _phiMap)
			{
				yulAssert(argValueId.value < m_valueIdToVars.size());
				for (auto const* var: m_valueIdToVars[argValueId.value])
					update({var}, phiValueIds, true);
			}
		}

		VarToValueIds::mapped_type const& lookupValues(Scope::Variable const& _variable) const
		{
			yulAssert(contains(_variable));
			return m_varToValueIds.at(&_variable);
		}

		ValueIdToVars::value_type const& lookupVariable(SSACFG::ValueId const& _valueId) const
		{
			yulAssert(_valueId.hasValue());
			yulAssert(_valueId.value < m_valueIdToVars.size());
			return m_valueIdToVars.at(_valueId.value);
		}

		std::set<Scope::Variable const*> variables() const;
		void debugPrint(SSACFG const& _cfg) const;
	private:
		void update(std::set<Scope::Variable const*> _var, std::set<SSACFG::ValueId> const& _values, bool append)
		{
			for (auto const* var: _var)
			{
				yulAssert(var);
				if (append)
					m_varToValueIds[var] += _values;
				else
					m_varToValueIds[var] = _values;
			}
			for (auto const& valueId: _values)
			{
				yulAssert(valueId.hasValue());
				if (append)
					m_valueIdToVars[valueId.value] += _var;
				else
					m_valueIdToVars[valueId.value] = _var;
			}
			/*for (auto const& valueId: _values)
			{
				yulAssert(valueId.hasValue());
				auto& assignedVars = m_valueIdToVars[valueId.value];
				auto pred = [this, valueId](Scope::Variable const* var)
				{
					return m_varToValueIds.at(var).count(valueId) == 0;
				};
				// todo replace by erase_if once cpp20 is available
				for (auto i = assignedVars.begin(), last = assignedVars.end(); i != last; )
					if (pred(*i))
						i = assignedVars.erase(i);
					else
						++i;
				assignedVars += _var;
			}*/
		}

		VarToValueIds m_varToValueIds{};
		ValueIdToVars m_valueIdToVars{};
	};
	explicit SSACFGValidator(Context const& _context):
		m_context(_context),
		m_currentVariableValues(_context.cfg.numValueIds())
	{}
	std::optional<std::vector<std::set<SSACFG::ValueId>>> consumeExpression(Expression const& _expression);
	std::optional<std::set<SSACFG::ValueId>> consumeUnaryExpression(Expression const& _expression);
	bool consumeBlock(Block const& _block);
	bool consumeStatement(Statement const& _statement);
	bool consumeConstantForLoop(ForLoop const& _loop, bool _conditionIsZero);
	bool consumeDynamicForLoop(ForLoop const& _loop);
	SSACFG::BasicBlock const& currentBlock() const
	{
		return m_context.cfg.block(m_currentBlock);
	}
	Scope::Variable const& resolveVariable(YulName _name) const;
	Scope::Function const& resolveFunction(YulName _name) const;
	std::set<SSACFG::ValueId> const& lookupIdentifier(Identifier const& _identifier) const;
	SSACFG::ValueId lookupLiteral(Literal const& _literal) const;
	/// @returns true if the call can continue, false otherwise
	bool validateCall(std::variant<SSACFG::BuiltinCall, SSACFG::Call> const& _kind, Identifier const& _functionName, size_t _numOutputs) const;
	void validatePhis(SSACFG::BlockId const& _blockId) const;

	SSACFG::BasicBlock::ConditionalJump const& expectConditionalJump() const;
	SSACFG::BasicBlock::Jump const& expectUnconditionalJump() const;
	SSACFG::BasicBlock::FunctionReturn const& expectFunctionReturn();
	/// Applys the phi functions of @a _target assuming an entry from @a _source.
	VariableMapping applyPhis(SSACFG::BlockId _source, SSACFG::BlockId _target);
	void advanceToBlock(SSACFG::BlockId _target);
	Context const& m_context;
	Scope* m_scope = nullptr;
    SSACFG::BlockId m_currentBlock;
	size_t m_currentOperation = std::numeric_limits<size_t>::max();
	VariableMapping m_currentVariableValues;
	struct LoopInfo
	{
		std::set<Scope::Variable const*> loopVariables;
		VariableMapping loopExitVariableValues;
		SSACFG::BlockId exitBlock;
		std::optional<VariableMapping> loopPostVariableValues;
		std::optional<SSACFG::BlockId> postBlock;
	};
	std::unique_ptr<LoopInfo> m_currentLoopInfo;
};
}
