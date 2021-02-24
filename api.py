import os
from flask import Flask, render_template, request, send_file
from flask_restful import Api, Resource, reqparse
import tempfile
from werkzeug.utils import secure_filename
import zipfile
import json

app = Flask(__name__)
api = Api(app)


def zipdir(dirPath=None, zipFilePath=None, includeDirInZip=False):
    if not zipFilePath:
        zipFilePath = dirPath + ".zip"
    if not os.path.isdir(dirPath):
        raise OSError("dirPath argument must point to a directory. "
            "'%s' does not." % dirPath)
    parentDir, dirToZip = os.path.split(dirPath)
    def trimPath(path):
        archivePath = path.replace(parentDir, "", 1)
        if parentDir:
            archivePath = archivePath.replace(os.path.sep, "", 1)
        if not includeDirInZip:
            archivePath = archivePath.replace(dirToZip + os.path.sep, "", 1)
        return os.path.normcase(archivePath)

    outFile = zipfile.ZipFile(zipFilePath, "w",
        compression=zipfile.ZIP_DEFLATED)
    for (archiveDirPath, dirNames, fileNames) in os.walk(dirPath):
        for fileName in fileNames:
            filePath = os.path.join(archiveDirPath, fileName)
            outFile.write(filePath, trimPath(filePath))
        if not fileNames and not dirNames:
            zipInfo = zipfile.ZipInfo(trimPath(archiveDirPath) + "/")
            outFile.writestr(zipInfo, "")
    outFile.close()


class Widoco(Resource):
    def post(self):
        os.system("rm -rf tmp")
        os.system("mkdir tmp")

        extend = "java -jar widoco.jar -outFolder tmp/WidocoDocs "

        data = request.form.get("data")
        data = json.loads(data)


        # If we have the ontology file
        if(request.files["ontoFile"]):
            file = request.files["ontoFile"]
            file.save(os.path.join("tmp/", secure_filename(file.filename)))
            file_stats = os.stat("tmp/"+file.filename)
            extend += "-ontFile tmp/" + file.filename + " "
        # If we have the ontology uri
        elif("ontoUri" in data):
            extend += "-ontUri " + data["ontoUri"] + " "
        # If we dont have anything
        else:
            return "Error no Ontology to make Documentation"

        # If we have configFile
        if("confFile" in data):
            extend += "-confFile " + data["confFile"] + " "
        # If we have getOntologyMetadata
        elif("getOntologyMetadata" in data):
            extend += "-getOntologyMetadata "

        # If we have oops
        if("oops" in data):
            extend += "-oops "

        # If we have rewriteAll
        if("rewriteAll" in data):
            extend += "-rewriteAll "

        # If we have crossRef
        if("crossRef" in data):
            extend += "-crossRef "

        # If we have saveConfig
        if("saveConfig" in data):
            extend += "-saveConfig " + data["saveConfig"] + " "

        # If we have usecustomStyle
        if("usecustomStyle" in data):
            extend += "-useCustomStyle "

        # If we have lang
        if("lang" in data):
            extend += "-lang " + data["lang"] + " "

        # If we have includeImportedOntologies
        if("includeImportedOntologies" in data):
            extend += "-includeImportedOntologies "

        # If we have htaccess
        if("htaccess" in data):
            extend += "-htaccess "

        # If we have webVowl
        if("webVowl" in data):
            extend += "-webVowl "

        # If we have licensius
        if("licensius" in data):
            extend += "-licensius "

        # If we have ignoreIndividuals
        if("ignoreIndividuals" in data):
            extend += "-ignoreIndividuals "

        # If we have analytics
        if("analytics" in data):
            extend += "-analytics " + data["analytics"] + " "

        # If we have doNotDisplaySerializations
        if("doNotDisplaySerializations" in data):
            extend += "-doNotDisplaySerializations "

        # If we have displayDirectImportsOnly
        if("displayDirectImportsOnly" in data):
            extend += "-displayDirectImportsOnly "

        # If we have rewriteBase
        if("rewriteBase" in data):
            extend += "-rewriteBase " + data["rewriteBase"] + " "

        # If we have excludeIntroduction
        if("excludeIntroduction" in data):
            extend += "-excludeIntroduction "

        # If we have uniteSections
        if("uniteSections" in data):
            extend += "-uniteSections "

        print(extend)

        os.system(extend)
        os.system(extend)

        zipdir("tmp/WidocoDocs/","tmp/WidocoDocs.zip",True)

        return send_file("tmp/WidocoDocs.zip", attachment_filename='WidocoDocs.zip')


api.add_resource(Widoco, "/")
app.run(host='0.0.0.0')
