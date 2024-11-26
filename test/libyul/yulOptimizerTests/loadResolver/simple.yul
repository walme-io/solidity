{
    sstore(calldataload(0), calldataload(10))
    let t := sload(calldataload(10))
    let q := sload(calldataload(0))
    mstore(t, q)
}
// ----
// step: loadResolver
//
// {
//     {
//         sstore(calldataload(0), calldataload(10))
//         let t := sload(calldataload(10))
//         mstore(t, sload(calldataload(0)))
//     }
// }
