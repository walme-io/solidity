{
    sstore(10, 20)
    // will be resolved
    sstore(30, sload(10))
    verbatim_0i_0o("test")
    // will not be resolved
    sstore(30, sload(10))
}
// ----
// step: loadResolver
//
// {
//     {
//         sstore(10, 20)
//         sstore(30, sload(10))
//         verbatim_0i_0o("test")
//         sstore(30, sload(10))
//     }
// }
