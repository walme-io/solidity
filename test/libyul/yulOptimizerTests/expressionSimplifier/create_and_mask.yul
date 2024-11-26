{
    // This is not fully simplified on purpose because we
    // need another split step in between. The full simplification
    // is tested in the fullSuite.
    let c := create(0, 0, 0x20)
    let a := and(c, 0xffffffffffffffffffffffffffffffffffffffff)
    let b := and(0xffffffffffffffffffffffffffffffffffffffff, create(0, 0, 0x20))
    sstore(a, b)
}
// ----
// step: expressionSimplifier
//
// {
//     {
//         let a := and(create(0, 0, 0x20), 0xffffffffffffffffffffffffffffffffffffffff)
//         sstore(a, and(0xffffffffffffffffffffffffffffffffffffffff, create(0, 0, 0x20)))
//     }
// }
