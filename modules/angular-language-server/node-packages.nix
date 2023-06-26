# This file has been generated by node2nix 1.11.1. Do not edit!
{
  nodeEnv,
  fetchurl,
  fetchgit,
  nix-gitignore,
  stdenv,
  lib,
  globalBuildInputs ? [],
}: let
  sources = {
    "@angular/language-service-13.3.8" = {
      name = "_at_angular_slash_language-service";
      packageName = "@angular/language-service";
      version = "13.3.8";
      src = fetchurl {
        url = "https://registry.npmjs.org/@angular/language-service/-/language-service-13.3.8.tgz";
        sha512 = "dA+uxtUO+7i5gMCwIMtaUMse6+Bep6JcDWo8GJ/nWS8c3GAS2E96Sm3NBycKWGaiz9HNOgO2cbpPlMifKPREow==";
      };
    };
    "vscode-jsonrpc-6.0.0" = {
      name = "vscode-jsonrpc";
      packageName = "vscode-jsonrpc";
      version = "6.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-jsonrpc/-/vscode-jsonrpc-6.0.0.tgz";
        sha512 = "wnJA4BnEjOSyFMvjZdpiOwhSq9uDoK8e/kpRJDTaMYzwlkrhG1fwDIZI94CLsLzlCK5cIbMMtFlJlfR57Lavmg==";
      };
    };
    "vscode-languageserver-7.0.0" = {
      name = "vscode-languageserver";
      packageName = "vscode-languageserver";
      version = "7.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver/-/vscode-languageserver-7.0.0.tgz";
        sha512 = "60HTx5ID+fLRcgdHfmz0LDZAXYEV68fzwG0JWwEPBode9NuMYTIxuYXPg4ngO8i8+Ou0lM7y6GzaYWbiDL0drw==";
      };
    };
    "vscode-languageserver-protocol-3.16.0" = {
      name = "vscode-languageserver-protocol";
      packageName = "vscode-languageserver-protocol";
      version = "3.16.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-protocol/-/vscode-languageserver-protocol-3.16.0.tgz";
        sha512 = "sdeUoAawceQdgIfTI+sdcwkiK2KU+2cbEYA0agzM2uqaUy2UpnnGHtWTHVEtS0ES4zHU0eMFRGN+oQgDxlD66A==";
      };
    };
    "vscode-languageserver-types-3.16.0" = {
      name = "vscode-languageserver-types";
      packageName = "vscode-languageserver-types";
      version = "3.16.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-types/-/vscode-languageserver-types-3.16.0.tgz";
        sha512 = "k8luDIWJWyenLc5ToFQQMaSrqCHiLwyKPHKPQZ5zz21vM+vIVUSvsRpcbiECH4WR88K2XZqc4ScRcZ7nk/jbeA==";
      };
    };
    "vscode-uri-3.0.3" = {
      name = "vscode-uri";
      packageName = "vscode-uri";
      version = "3.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-uri/-/vscode-uri-3.0.3.tgz";
        sha512 = "EcswR2S8bpR7fD0YPeS7r2xXExrScVMxg4MedACaWHEtx9ftCF/qHG1xGkolzTPcEmjTavCQgbVzHUIdTMzFGA==";
      };
    };
  };
in {
  "@angular/language-server-13.3.4" = nodeEnv.buildNodePackage {
    name = "_at_angular_slash_language-server";
    packageName = "@angular/language-server";
    version = "13.3.4";
    src = fetchurl {
      url = "https://registry.npmjs.org/@angular/language-server/-/language-server-13.3.4.tgz";
      sha512 = "9I6h66TPAY3CbKkBtsj5XAlfJhhexD1KSy7gfe2ZXQsrXygCj6BvjaaDGK5DKs2ea/LLtIDKGb9GAlrJL3dnrw==";
    };
    dependencies = [
      sources."@angular/language-service-13.3.8"
      sources."vscode-jsonrpc-6.0.0"
      sources."vscode-languageserver-7.0.0"
      sources."vscode-languageserver-protocol-3.16.0"
      sources."vscode-languageserver-types-3.16.0"
      sources."vscode-uri-3.0.3"
    ];
    buildInputs = globalBuildInputs;
    meta = {
      description = "LSP server for Angular Language Service";
      homepage = "https://github.com/angular/vscode-ng-language-service#readme";
      license = "MIT";
    };
    production = true;
    bypassCache = true;
    reconstructLock = true;
  };
}
