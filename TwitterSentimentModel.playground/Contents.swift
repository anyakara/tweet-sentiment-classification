import Cocoa
import CreateML

// mark with a 'try' because in the case that a specific file does not exist on the computer, precautions are taken to prevent crashing of the app / product.
let data = try MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/ananyakarra/Downloads/twitter-sanders-apple3.csv"))

// either randomly select the values, or spit the data into training and testing data

// a seed is used to reconstruct the 'randomness' of a random number generator
// reproduce for debugging to generate the same randomness
let(trainingData, testingData) = data.randomSplit(by: 0.8, seed: 5)

// this will become the model for training
let sentimentClassifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "class")

// to evauluate the accuracy
let evaluationMetrics = sentimentClassifier.evaluation(on: trainingData, textColumn: "text", labelColumn: "class")

let evaluationAccuracy = (1.0 - evaluationMetrics.classificationError) * 100

let metadata = MLModelMetadata(author: "Ananya Karra", shortDescription: "A model trained to classify the sentiments evoked in Twitter's tweets", version: "1.0")

try sentimentClassifier.write(to: URL(fileURLWithPath:"/Users/ananyakarra/Downloads/TweetSentimentClassifier.mlmodel"))

try sentimentClassifier.prediction(from: "This coronavirus pandemic has been really putting me to the test. I hate this.")

try sentimentClassifier.prediction(from: "I think @CocaCola ads are just ok.")
