{ pkgs, ... }:
{
  home.shellAliases = {
    memsql = "mysql -h 127.0.0.1 -u root --prompt='memsql> '";
    single = "cd $PATH_TO_MEMSQL/debug; ./memsqld --singlebox";
    singler = "cd $PATH_TO_MEMSQL/release; ./memsqld --singlebox";
    distributed = "cd $PATH_TO_MEMSQL/debug; ./memsqld";
    distributedr = "cd $PATH_TO_MEMSQL/release; ./memsqld";
    singled = "cd $PATH_TO_MEMSQL/debug; gdb -ex run --args ./memsqld --singlebox";
    distributedd = "cd $PATH_TO_MEMSQL/debug; gdb -ex run --args ./memsqld";
  };

  home.sessionVariables = {
    MEMSQL_PLEASE_DOCKER_CPU_SHARES = "{\\\"default\\\":10}";
  };

  home.packages = with pkgs; [
    coder
    flamegraph
  ];
}
