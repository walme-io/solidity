{
    mstore(0, mod(add(mload(0), mload(1)), 32))
}
// ----
// step: expressionSimplifier
//
// {
//     {
//         mstore(0, addmod(mload(0), mload(1), 32))
//     }
// }
