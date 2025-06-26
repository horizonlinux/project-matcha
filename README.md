# Project Matcha

# Purpose

This repository is a openSuse based image built using Universal Blue techonologies.
It is meant to bring best of both worlds (openSuse and Atomic Fedora) into one thing. It is also meant to gave openSuse missing 3rd flavour which is stable but more up to date.
This image might be later used for building Horizon images.

#### Container Signing

Container signing is important for end-user security and is enabled on all Universal Blue images. It is recommended you set this up, and by default the image builds *will fail* if you don't.

This provides users a method of verifying the image.

1. Install the [cosign CLI tool](https://edu.chainguard.dev/open-source/sigstore/cosign/how-to-install-cosign/#installing-cosign-with-the-cosign-binary)

2. Run inside your repo folder:

    ```bash
    cosign generate-key-pair
    ```

    
    - Do NOT put in a password when it asks you to, just press enter. The signing key will be used in GitHub Actions and will not work if it is encrypted.

> [!WARNING]
> Be careful to *never* accidentally commit `cosign.key` into your git repo.

3. Add the private key to GitHub

    - This can also be done manually. Go to your repository settings, under `Secrets and Variables` -> `Actions`
    ![image](https://user-images.githubusercontent.com/1264109/216735595-0ecf1b66-b9ee-439e-87d7-c8cc43c2110a.png)
    Add a new secret and name it `SIGNING_SECRET`, then paste the contents of `cosign.key` into the secret and save it. Make sure it's the .key file and not the .pub file. Once done, it should look like this:
    ![image](https://user-images.githubusercontent.com/1264109/216735690-2d19271f-cee2-45ac-a039-23e6a4c16b34.png)

    - (CLI instructions) If you have the `github-cli` installed, run:

    ```bash
    gh secret set SIGNING_SECRET < cosign.key
    ```

4. Commit the `cosign.pub` file to the root of your git repository.

# Want to learn more?
Read more about building Universal Blue images here: https://github.com/ublue-os/image-template
- [bOS](https://github.com/bsherman/bos)
- [Homer](https://github.com/bketelsen/homer/)
- [Amy OS](https://github.com/astrovm/amyos)
- [VeneOS](https://github.com/Venefilyn/veneos)
