[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls13
$artistsearch = "Dua Lipa"

$search = "https://corsproxy.io/?https://tidal.401658.xyz/search/?a=$artistsearch"
$searchreturn = Invoke-RestMethod -Method Get -Uri $search

$artist = "https://corsproxy.io/?https://tidal.401658.xyz/artist/?f=$(($searchreturn.artists.items | sort-object popularity -Descending |select-object -First 1).id)"
$artistreturn = Invoke-RestMethod -Method Get -Uri $artist

$artistreturn.id | select-object -Skip 1 | foreach-object {
$track = "https://corsproxy.io/?https://tidal.401658.xyz/track/?id=$_&quality=LOSSLESS"
$trackreturn = Invoke-RestMethod -Method Get -Uri $track
$item = $($trackreturn[0];$trackreturn[2]) | select-object {$_.artist.name}, {$_.album.title}, title, trackNumber, OriginalTrackUrl | ft
$item
}