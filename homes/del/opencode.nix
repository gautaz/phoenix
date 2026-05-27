{pkgs, ...}: {
  programs.opencode = {
    enable = true;
    package = pkgs.opencode;
    settings = {
      autoupdate = false;
      model = "opencode/big-pickle";
      provider.ollama = {
        npm = "@ai-sdk/openai-compatible";
        name = "Ollama (local)";
        options.baseURL = "http://localhost:11434/v1";
        models = {
          "qwen2.5-coder:3b".name = "Qwen 2.5 Coder 3B (local)";
          "qwen3:4b".name = "Qwen 3 4B (local)";
        };
      };
      agent.build = {
        permission = {
          edit = "deny";
          external_directory = "deny";
        };
        prompt = "{file:${./opencode-build-prompt.md}}";
      };
      agent.edit = {
        description = "Edit source files when asked to modify code";
        # model = "ollama/qwen2.5-coder:3b";
        mode = "subagent";
        prompt = "{file:${./opencode-edit-prompt.md}}";
        permission = {
          bash = "deny";
          edit = "allow";
          external_directory = "deny";
          glob = "allow";
          grep = "allow";
          list = "allow";
          lsp = "allow";
          read = "allow";
          skill = "deny";
          task = "deny";
          todowrite = "deny";
          webfetch = "deny";
          websearch = "deny";
        };
      };
      agent.explore = {
        description = "Find files, search code, and answer questions about the codebase and local files";
        # model = "ollama/qwen3:4b";
        mode = "subagent";
        prompt = "{file:${./opencode-explore-prompt.md}}";
        permission.external_directory = {
          "*" = "ask";
          "/nix/store/**" = "allow";
        };
      };
    };
  };
}
