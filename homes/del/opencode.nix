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
          "qwen2.5-coder:1.5b".name = "Qwen 2.5 Coder 1.5B (local)";
        };
      };
      agent.build = {
        permission = {
          edit = "deny";
          external_directory = "deny";
        };
        prompt = "{inline: You are a senior software engineer. When source files need to be modified, delegate to the edit subagent via the Task tool. When searching external directories (outside the project tree), delegate to the explore subagent.}";
      };
      agent.edit = {
        description = "Edits source files when asked to modify code";
        model = "ollama/qwen2.5-coder:1.5b";
        mode = "subagent";
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
        model = "ollama/qwen2.5-coder:1.5b";
        mode = "subagent";
        permission.external_directory = {
          "*" = "ask";
          "/nix/store/**" = "allow";
        };
      };
    };
  };
}
