Import-Module QuiteShortAliases
Import-Module Bino.Bootstrap
Import-Module Bino.PersonalAliases

Set-Alias gcl gcloud

function Set-Up {
    gcloud auth login
    function Get-GcloudSecret([string] $name) {
        gcloud secrets versions access latest --secret="$name" --project="bino-personal"
    }
    mkdir -p ~/.ssh
    Get-GcloudSecret "SSH_DEV_KEY" | cat > ~/.ssh/id_rsa && chmod 600 ~/.ssh/id_rsa

    ngrok config add-authtoken $(Get-GcloudSecret "NGROK_API_TOKEN")
}


function p() {
    npm exec pnpm $args
}
function nest() {
    npm exec @nestjs/cli $args
}