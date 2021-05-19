self: super:

{
  neovim = super.neovim.override {
    extraPythonPackages = [
      self.pythonPackages.websocket_client
      self.pythonPackages.sexpdata
    ];
  };
}
