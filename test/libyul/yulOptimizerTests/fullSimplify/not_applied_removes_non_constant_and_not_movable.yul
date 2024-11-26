// div is eliminated, but create has side-effects.
{
	let a := div(create(0, 0, 0), 0)
	mstore(0, a)
}
// ----
// step: fullSimplify
//
// {
//     {
//         pop(create(0, 0, 0))
//         mstore(0, 0)
//     }
// }
