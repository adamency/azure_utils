#===== Connect in SSH to appservice $args[0]

# README<
# The script allows to connect to an appservice with SSH directly in the terminal instead of the Azure Portal method in which you need to open a browser tab.
# The only API endpoint provided by Azure for this is a bit unorthodox, and creates an SSH tunnel on your local machine on a random port which you can then `ssh` into.
# The tunnel is terminated by this function after exitting the ssh session.
# >README

function azappservicessh {
    $responseObject = az webapp create-remote-connection -g usercube-qa -n $args[0] &
    # Retrieve Port of Tunnel from output message (stored as error...)
    while (!$port)
    {
      $port = ($responseObject.ChildJobs[0].Error | awk '/tunnel on port/ {print $NF}')
      sleep 1
    }
    $jobId = ($responseObject.Id)
    ssh root@127.0.0.1 -p $port
    Remove-Job -Id $jobId -Force
}
