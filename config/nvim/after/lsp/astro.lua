return {
  before_init = function(_, config)
    local typescript = require("mason-lspconfig.typescript")
    local install_dir = vim.fs.joinpath(vim.fn.expand("$MASON"), "packages", "typescript-language-server")
    local tsdk, server_path = typescript.resolve_tsdk(install_dir, config.root_dir)

    config.init_options.typescript.tsdk = assert(tsdk, "Could not resolve the TypeScript SDK")
    config.init_options.typescript.serverPath = server_path
  end,
}
