{
    // This is not fully simplified on purpose because we
    // need another split step in between. The full simplification
    // is tested in the fullSuite.
    let x := calldataload(0)
    let a := and(0xff, shr(248, shl(248, shr(248, and(x, 0xf)))))
    let b := shl(12, shr(4, and(x, 0xf0f0)))
    let c := shl(12, shr(4, and(0xf0f0, x)))
    let d := shl(12, shr(255, and(0xf0f0, x)))
    let e := shl(255, shr(4, and(0xf0f0, x)))
    let f := shl(12, shr(256, and(0xf0f0, x)))
    let g := shl(256, shr(4, and(0xf0f0, x)))
    sstore(10, a)
    sstore(11, b)
    sstore(12, c)
    sstore(13, d)
    sstore(14, e)
    sstore(15, f)
    sstore(16, g)
}
// ====
// EVMVersion: >byzantium
// ----
// step: expressionSimplifier
//
// {
//     {
//         let x := calldataload(0)
//         let a := and(and(shr(248, x), 0), 255)
//         let b := shl(12, and(shr(4, x), 3855))
//         let c := shl(12, and(shr(4, x), 3855))
//         let d := shl(12, and(shr(255, x), 0))
//         let e := shl(255, and(shr(4, x), 3855))
//         let f := 0
//         let g := 0
//         sstore(10, a)
//         sstore(11, b)
//         sstore(12, c)
//         sstore(13, d)
//         sstore(14, e)
//         sstore(15, f)
//         sstore(16, g)
//     }
// }
