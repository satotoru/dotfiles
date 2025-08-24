-- 言語固有のシンタックスサポート
return {
  -- TypeScript/JavaScript
  {
    "leafgarland/typescript-vim",
    ft = { "typescript", "typescriptreact" },
  },
  
  -- CoffeeScript
  {
    "kchmck/vim-coffee-script",
    ft = "coffee",
  },
  
  -- Slim templates
  {
    "slim-template/vim-slim",
    ft = "slim",
  },
  
  -- PlantUML
  {
    "aklt/plantuml-syntax",
    ft = "plantuml",
    config = function()
      -- Chromeでプレビューを開くコマンド（旧設定より）
      vim.g.plantuml_previewer = {
        chrome = {
          cmd = "open -a 'Google Chrome'",
          args = "%s",
        }
      }
    end,
  },
  
  -- Terraform
  {
    "hashivim/vim-terraform",
    ft = { "terraform", "tf", "hcl" },
    config = function()
      vim.g.terraform_align = 1
      vim.g.terraform_fmt_on_save = 1
    end,
  },
  
  -- GraphQL
  {
    "jparise/vim-graphql",
    ft = { "graphql", "gql" },
  },
  
  -- Fish shell
  {
    "dag/vim-fish",
    ft = "fish",
  },
}