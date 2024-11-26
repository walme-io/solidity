{
    let a := add(7, sub(mload(0), 7))
    mstore(a, 0)
}
// ----
// step: fullSimplify
//
// { { mstore(mload(0), 0) } }
