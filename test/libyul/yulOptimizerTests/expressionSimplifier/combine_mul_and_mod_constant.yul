{
    mstore(0, mod(mul(mload(0), mload(1)), 32))
}
// ----
// step: expressionSimplifier
//
// {
//     {
//         mstore(0, mulmod(mload(0), mload(1), 32))
//     }
// }
