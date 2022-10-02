import groovy.io.FileType
import java.awt.image.BufferedImage
import qupath.lib.images.servers.ImageServerProvider
import qupath.lib.images.servers.ImageServerMetadata
import qupath.lib.gui.commands.ProjectCommands
import qupath.lib.gui.tools.GuiTools
import qupath.lib.gui.images.stores.DefaultImageRegionStore
import qupath.lib.gui.images.stores.ImageRegionStoreFactory

//Did we receive a string via the command line args keyword?
if (args.size() > 0)
    selectedDir = new File(args[0])
else
    selectedDir = Dialogs.promptForDirectory(null)

if (selectedDir == null)
    return
    
// Check if we already have a QuPath Project directory in there...
projectName = "QuPathProject"
File directory = new File(selectedDir.toString() + File.separator + projectName)

if (!directory.exists())
{
    println "No project directory, creating one!"
    directory.mkdirs()
}

// Create project
def project = Projects.createProject(directory , BufferedImage.class)

// Set up cache
def imageRegionStore = ImageRegionStoreFactory.createImageRegionStore(QuPathGUI.getTileCacheSizeBytes());

// Add files to the project
selectedDir.eachFileRecurse (FileType.FILES) { file ->
    def imagePath = file.getCanonicalPath()
    
    // Skip the project directory itself
    if (file.getCanonicalPath().startsWith(directory.getCanonicalPath() + File.separator))
        return
        
    // I tend to add underscores to the end of filenames I want excluded
    // MacOSX seems to add hidden files that start with a dot (._), don't add those
    if (file.getName().endsWith("_") || file.getName().startsWith("."))
        return

    // Skip the .geojson file
    if (file.getCanonicalPath().endsWith(".geojson"))
        return

    // Skip the log files
    if (file.getCanonicalPath().endsWith(".err") || file.getCanonicalPath().endsWith(".out"))
        return
    
    // Is it a file we know how to read?
    def support = ImageServerProvider.getPreferredUriImageSupport(BufferedImage.class, imagePath)
    if (support == null)
        return

    // iterate through the scenes contained in the image file
    support.builders.eachWithIndex { builder, i -> 
        sceneName = file.getName()
        if (support.builders.size() > 1)
            sceneName += " - Scene #" + (i+1)

        // Add a new entry for the current builder and remove it if we weren't able to read the image.
        // I don't like it but I wasn't able to use PathIO.readImageData().
        entry = project.addImage(builder)
    
        try {
            imageData = entry.readImageData()
        } catch (Exception ex) {
            println sceneName +" -- Error reading image data " + ex
            project.removeImage(entry, true)
            return
        }
        
        println "Adding: " + sceneName
    
        // Set a particular image type automatically (based on /qupath/lib/gui/QuPathGUI.java#L2847)
        def imageType = GuiTools.estimateImageType(imageData.getServer(), imageRegionStore.getThumbnail(imageData.getServer(), 0, 0, true));
        imageData.setImageType(imageType)
        println "Image type estimated to be " + imageType

        def metabuilder = new ImageServerMetadata.Builder(imageData.getServer().getMetadata())
        metabuilder.magnification(40.0)
        metabuilder.pixelSizeMicrons(0.25, 0.25)
        metabuilder.name(sceneName)
        imageData.getServer().setMetadata(metabuilder.build())

        // setPixelSizeMicrons(imageData, 0.25, 0.25, 1)

        // Set the magnification & pixel size (be cautious!!!)
        // def metadata = imageData.getServer().getMetadata().duplicate()
        // metadata.pixelWidthMicrons = 0.25
        // metadata.pixelHeightMicrons = 0.25
        // metadata.magnification = 40.0
        
        // metadata.pixelCalibration.pixelWidth.value = 0.25
        // metadata.pixelCalibration.pixelHeight.value = 0.25

        // Adding image data to the project entry
        entry.saveImageData(imageData)
    
        // Write a thumbnail if we can
        entry.setThumbnail(ProjectCommands.getThumbnailRGB(imageData.getServer()))
    
        // Add an entry name (the filename)
        entry.setImageName(sceneName)
    }
}

// Changes should now be reflected in the project directory
project.syncChanges()