def annotations = getAnnotationObjects()
boolean prettyPrint = true
def gson = GsonTools.getInstance(prettyPrint)

def path = args[0]
def file = new File(path)
file.write(gson.toJson(annotations))