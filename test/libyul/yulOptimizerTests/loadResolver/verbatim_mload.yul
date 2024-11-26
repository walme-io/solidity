{
    mstore(10, 20)
    // cannot be resolved because of verbatim
    sstore(0, mload(10))
    verbatim_0i_0o("test")
}
// ----
// step: loadResolver
//
// {
//     {
//         mstore(10, 20)
//         sstore(0, mload(10))
//         verbatim_0i_0o("test")
//     }
// }
