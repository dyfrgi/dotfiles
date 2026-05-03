{  
  virtualisation.oci-containers = {
    backend = "podman";
    containers.homeassistant = {
      volumes = [ "home-assistant:/config" ];
      environment.TZ = "America/New_York";
      image = "ghcr.io/home-assistant/home-assistant:stable";
      extraOptions = [ 
        "--network=host" 
	"--pull=newer"
      ];
    };
  };
}
