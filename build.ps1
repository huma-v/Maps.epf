$ErrorActionPreference = "Stop"

# Read .env file into environment variables
if (Test-Path .env -PathType Leaf) {
    Get-Content .env | ForEach-Object {
        $name, $value = $_.split('=')
        Set-Item env:$name -Value $value
    }
}

# Create build output directory
New-Item .\build -ItemType Directory -Force

New-Item .\build\download -ItemType Directory -Force

# Download dependencies
if (-not (Test-Path .\build\download\leaflet)) {
	Invoke-WebRequest "https://github.com/Leaflet/Leaflet/releases/download/v1.8.0/leaflet.zip" -OutFile .\build\download\leaflet.zip
	Expand-Archive .\build\download\leaflet.zip -DestinationPath .\build\download\leaflet\ -Force
}


if (-not (Test-Path .\build\download\Leaflet.markercluster-1.1.0)) {
	Invoke-WebRequest "https://github.com/Leaflet/Leaflet.markercluster/archive/v1.1.0.zip" -Outfile .\build\download\Leaflet.markercluster.zip
	Expand-Archive .\build\download\Leaflet.markercluster.zip -DestinationPath .\build\download\ -Force

}

if (-not (Test-Path .\build\download\Leaflet.GeometryUtil-0.10.3)) {
    Invoke-WebRequest "https://github.com/makinacorpus/Leaflet.GeometryUtil/archive/0.10.3.zip" -Outfile .\build\download\Leaflet.GeometryUtil.zip
    Expand-Archive .\build\download\Leaflet.GeometryUtil.zip -DestinationPath .\build\download\ -Force
}

if (-not (Test-Path .\build\download\leaflet-arrowheads-es5-bcc98c30a2196498fc36d27a6df418e3f5633bea)) {
    Invoke-WebRequest "https://github.com/huma-v/leaflet-arrowheads-es5/archive/bcc98c30a2196498fc36d27a6df418e3f5633bea.zip" -Outfile .\build\download\leaflet-arrowheads.zip
    Expand-Archive .\build\download\leaflet-arrowheads.zip -DestinationPath .\build\download\ -Force
}

# Using a fork that fixes the loop problem
if (-not (Test-Path .\build\download\Leaflet.PolylineOffset-4a52e28b9c32ab9c850315d451ed470529ac55dd)) {
    Invoke-WebRequest "https://github.com/higaa/Leaflet.PolylineOffset/archive/4a52e28b9c32ab9c850315d451ed470529ac55dd.zip" -Outfile .\build\download\Leaflet.PolylineOffset.zip
    Expand-Archive .\build\download\Leaflet.PolylineOffset.zip -DestinationPath .\build\download\ -Force
}

Remove-Item .\build\resources -Recurse -Force -ErrorAction SilentlyContinue
New-Item .\build\resources -ItemType Directory

New-Item .\build\resources\leaflet -ItemType Directory
@("leaflet.js", "leaflet.css", "images") |
    ForEach-Object { ".\build\download\leaflet\${_}" } |
    Copy-Item -Destination .\build\resources\leaflet\ -Recurse

New-Item .\build\resources\Leaflet.markercluster -ItemType Directory
@("MIT-LICENCE.txt", "dist\leaflet.markercluster.js", "dist\MarkerCluster.css", "dist\MarkerCluster.Default.css") |
    ForEach-Object { ".\build\download\Leaflet.markercluster-1.1.0\${_}" } |
    Copy-Item -Destination .\build\resources\Leaflet.markercluster\

New-Item .\build\resources\Leaflet.GeometryUtil -ItemType Directory
@("LICENSE", "src\leaflet.geometryutil.js") |
    ForEach-Object { ".\build\download\Leaflet.GeometryUtil-0.10.3\${_}" } |
    Copy-Item -Destination .\build\resources\Leaflet.GeometryUtil\

New-Item .\build\resources\leaflet-arrowheads -ItemType Directory
@("LICENSE", "src\leaflet-arrowheads.js") |
    ForEach-Object { ".\build\download\leaflet-arrowheads-es5-bcc98c30a2196498fc36d27a6df418e3f5633bea\${_}" } |
    Copy-Item -Destination .\build\resources\leaflet-arrowheads\

New-Item .\build\resources\Leaflet.PolylineOffset -ItemType Directory
@("LICENSE", "leaflet.polylineoffset.js") |
    ForEach-Object { ".\build\download\Leaflet.PolylineOffset-4a52e28b9c32ab9c850315d451ed470529ac55dd\${_}" } |
    Copy-Item -Destination .\build\resources\Leaflet.PolylineOffset\

# Copy over extra assets
Copy-Item .\assets .\build\resources\ -Recurse

Compress-Archive .\build\resources\* .\build\resources.zip -Force

Remove-Item .\build\MapsEpf -Recurse -ErrorAction SilentlyContinue
Copy-Item .\MapsEpf .\build\MapsEpf -Recurse

# Copy over the template file
New-Item .\build\MapsEpf\MapsEpf\Templates\АрхивРесурсов\Ext -ItemType Directory
Copy-Item .\build\resources.zip .\build\MapsEpf\MapsEpf\Templates\АрхивРесурсов\Ext\Template.bin

# Build the epf
$designer = Start-Process "${env:1C_HOME}\bin\1cv8.exe" "DESIGNER /LoadExternalDataProcessorOrReportFromFiles .\build\MapsEpf\MapsEpf.xml .\build\Maps.epf" -PassThru -Wait
if ($designer.ExitCode -ne 0) {
	throw "Error building epf!";
}
