import qupath.lib.io.GsonTools

def imageData = getCurrentImageData()

// Instantiate tools
def gson=GsonTools.getInstance(true);

// Prepare template
def type = new com.google.gson.reflect.TypeToken<List<qupath.lib.objects.PathObject>>() {}.getType();
println(args[0])
def json_fp = new File(args[0])

// Deserialize
def json_text = json_fp.getText('UTF-8')
if (json_text.startsWith("[")) {
    deserializedAnnotations = gson.fromJson(json_text, type);
} else {
    deserializedAnnotations = gson.fromJson('[' + json_text + ']', type);
}

// Add to image
addObjects(deserializedAnnotations);

// Resolve hierarchy
resolveHierarchy()