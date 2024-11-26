{
    let a := 0
    let b := 1
    let c := 2
    sstore(a, b)
    mstore(900, 7)
    let d := staticcall(10000, 10, 0, 200, 0, 200)
    sstore(add(a, 1), mload(900))
    // Main test objective: replace this sload.
    mstore(0, sload(a))
}
// ====
// EVMVersion: >=byzantium
// ----
// step: loadResolver
//
// {
//     {
//         let a := 0
//         let b := 1
//         sstore(a, b)
//         mstore(900, 7)
//         pop(staticcall(10000, 10, 0, 200, 0, 200))
//         sstore(1, mload(900))
//         mstore(0, b)
//     }
// }
