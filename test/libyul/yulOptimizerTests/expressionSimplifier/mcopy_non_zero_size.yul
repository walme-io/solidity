{
    calldatacopy(0, 0, 0x60)

    mcopy(0x20, 0x40, 0x20)

    return(0, 0x60)
}
// ====
// EVMVersion: >=cancun
// ----
// step: expressionSimplifier
//
// {
//     {
//         calldatacopy(0, 0, 0x60)
//         mcopy(0x20, 0x40, 0x20)
//         return(0, 0x60)
//     }
// }
