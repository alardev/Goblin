pkgs: {
  enable = true;
  package = (
    pkgs.ungoogled-chromium.override {
      enableWideVine = true;
      commandLineArgs = [
        "--enable-features=AcceleratedVideoEncoder,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE"
        "--enable-features=VaapiIgnoreDriverChecks,VaapiVideoDecoder,PlatformHEVCDecoderSupport"
        "--enable-features=UseMultiPlaneFormatForHardwareVideo"
        "--enable-features=SkiaGraphite"
        "--enable-unsafe-webgpu"
        "--ignore-gpu-blocklist"
        "--enable-zero-copy"
        "--enable-gpu-compositing"
        "--enable-gpu-rasterization"
        "--enable-native-gpu-memory-buffers"
        "--enable-oop-rasterization"
        "--canvas-oop-rasterization"
        "--enable-raw-draw"
        "--use-vulkan"
        "--enable-accelerated-video-decode"
        "--enable-accelerated-mjpeg-decode"
      ];
    }
  );
  extensions = [
    "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
  ];
  # extraOpts = {
  #   "ExtensionManifestV2Availability" = 2;
  #   "SpellcheckEnabled" = true;
  #   "SpellcheckLanguage" = [
  #     "en-GB"
  #     "et"
  #     "uk"
  #   ];
  # };
}
