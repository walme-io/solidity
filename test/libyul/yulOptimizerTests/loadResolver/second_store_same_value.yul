{
    let x := calldataload(1)
    sstore(x, 7)
    sstore(calldataload(0), 7)
    // We can replace this because both values that were
    // written are 7.
    mstore(0, sload(x))
}
// ----
// step: loadResolver
//
// {
//     {
//         let x := calldataload(1)
//         sstore(x, 7)
//         sstore(calldataload(0), 7)
//         mstore(0, sload(x))
//     }
// }
