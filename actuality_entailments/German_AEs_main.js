PennController.ResetPrefix(null); // Shorten command names (keep this line here))

Header(
   // void
)
.log( "PROLIFIC_ID" , GetURLParameter("id") )

//DebugOff()   // Uncomment this line for publication

Sequence("introduction", "consent", "commitment", "instructions", "practice-SPR", "transition-SPR", rshuffle(randomize("SPR-trial-plain"), randomize("SPR-trial-attention")), "Background-language", "Background-demographic", "send", "prolific")

newTrial("introduction",
    defaultText
        .print()
    ,
    newText("header-1", "<h2> Willkommen zu unserer Sprachstudie!</h2>")
    ,
    newText("header-2", "<h3>Zweck der Befragung:</h3>")
    ,
    newText("text-2", "In dieser Studie untersuchen wir, ein Forschungsteam der University of Edinburgh und der Ruhr-Universität Bochum, wie Sprecherinnen und Sprecher des Deutschen Sätze verarbeiten. Die Studie ist Teil unserer Forschung zu Ähnlichkeiten und Unterschieden zwischen verschiedenen Sprachen.")
    ,
    newText("header-3", "<h3>Teilnahmevoraussetzung:</h3>")
    ,
    newText("text-3", "Um an dieser Studie teilnehmen zu können, müssen Sie Deutsch als Muttersprache sprechen und aktuell in Deutschland leben.")
    ,
    newText("header-4", "<h3>Ablauf:</h3>")
    ,
    newText("text-4", "<b>Die Studie wird insgesamt etwa 15-20 Minuten in Anspruch nehmen. Bevor Sie mit der Bearbeitung anfangen, möchten wir Sie über den Ablauf informieren.</b>")
    ,
    newText("text-5","<li> Als Erstes klären wir Sie über die Verarbeitung Ihrer Daten auf.</li>")
    ,
    newText("text-6","<li> Dann geben wir Ihnen eine kurze Anleitung zur Bearbeitung der Aufgabe.</li>")
    ,
    newText("text-7", "<li> Sie durchlaufen zwei Übungsdurchgänge, um sich mit der Aufgabe vertraut zu machen.</li>")
    ,
    newText("text-11", "<li> Zum Schluss erfassen wir ein paar Informationen zu Ihrem Hintergrund (z.B. Alter, Dialekt). </li>")
    ,
    newCanvas("empty canvas-commit", 1, 20) // add some space above Continue the button
    .print()
    ,
    newButton("wait-intro", "Weiter zur Datenschutzerklärung")
        .center()
        .print()
        ,
    newCanvas("empty canvas", 1, 40) //add some space below the Continue button
    .print()
    ,
    getButton("wait-intro")
    .wait()
)

//Data handling 
newTrial("consent",
    newHtml("consent_form", "data_handling.html")
        .cssContainer({"width":"720px"})
        .checkboxWarning("Sie müssen der Datenschutzerklärung zustimmen, um fortzufahren.")
        .print()
        .center()
    ,
    newButton("button-consent", "Zustimmen und weiter")
        .center()
        .print()
        ,          
        newCanvas("empty canvas", 1, 40) 
    .print()
    ,
    getButton("button-consent")
    .wait(getHtml("consent_form").test.complete()
                  .failure(getHtml("consent_form").warn()) 
)
)
    

newTrial("commitment",
    newText("commit-1", "<h2> Selbstverpflichtung </h2>").print()
    .print()
    ,
    newText("commit-2", "Die Qualität unserer Daten ist uns wichtig. Damit wir korrekte Schlüsse aus den Studienergebnissen ziehen können, sind wir darauf angewiesen, dass Sie die Aufgaben in diesem Experiment aufmerksam und gewissenhaft erledigen.")
    .print()
    ,
    newText("<p>Versichern Sie, die Aufgaben in diesem Experiment aufmerksam und gewissenhaft zu erledigen?</p>")
    .bold()
    .print()
    ,
    newScale("response", " Ja ", " Nein ")
        .labelsPosition("right")
        .radio()    
        .center()
        .vertical()
        .once()
        .print()
        .log()      
    ,
    newCanvas("empty canvas-commit", 1, 40) 
    .print()
    ,
    // Initially hidden 'Continue' button
    newButton("continue", "Vielen Dank! Weiter zur Anleitung")
       // .hidden()  // Start with the button hidden
        //.print()
       .center()
    ,
    // If 'No' or 'Not sure' are selected, show a message and abort the experiment
    newText("abort-message", "Sie können leider nicht an dem Experiment teilnehmen. Bitte schließen Sie die Seite.")
        .color("red")
        .bold()
        .center()
        ,
    getScale("response").wait() // Wait for the participant to select an option
        //.callback( 
            .test.selected(" Ja ")
            .success( getButton("continue").print())
            .failure( getText("abort-message").print() ) 
      //  )
    ,
    // Wait for the "Continue" button to be clicked (if it becomes visible)
    getButton("continue").wait()
)

// Instructions
newTrial("instructions",
    defaultText
        .print()
    ,
    newText("instructions-h2", "<h2>Anleitung</h2>")
    ,
    newText("t-spr-1", "Bei dieser Studie handelt es sich um ein so genanntes 'self-paced reading'-Experiment.")
    ,
    newText("t-spr-2", "Dabei präsentieren wir Ihnen einzelne Sätze abschnittsweise und bitten Sie, diese in ihrem eigenen Tempo zu lesen.")
    ,
    newText("t-spr-4", "<p>In jedem Durchgang sehen Sie auf dem Bildschirm zunächst nur einen Strich. Jedes Mal, wenn Sie die <b>Leertaste</b> drücken, wird ein neuer Teil des Satzes angezeigt.</p>")
    ,
    newText("t-spr-6", "Ihre Aufgabe ist, den gesamten Satz zu lesen, indem Sie die Leertaste drücken, um den jeweils folgenden Abschnitt aufzudecken. Versuchen Sie bitte, den Satz in ihrem normalen Lesetempo zu lesen. Sie können sich so viel Zeit nehmen, wie Sie für das Lesen jedes Abschnitts benötigen, sollten aber unnötig lange Pausen vermeiden.")
    ,
    newText("t-spr-8", "<p>Es ist wichtig, dass Sie die Testsätze sorgfältig lesen. Daher stellen wir Ihnen nach einigen Testsätzen eine Frage, um Ihr Verständnis zu überprüfen. Bitte beantworten Sie diese Fragen, indem Sie eine der beiden angegebenen Optionen auswählen. Sie können die richtige Antwort entweder anklicken oder auf Ihrer Tastatur die Taste für die entsprechende Nummer ('1' oder '2') drücken. Mit der <b>Enter</b>-Taste gelangen Sie zum nächsten Satz.</p>")
    ,
    newText("t-spr-10", "Im nächsten Schritt präsentieren wir Ihnen einige Übungsaufgaben, damit Sie sich mit der Aufgabe vertraut machen können.")
    ,
    newCanvas("empty canvas-2", 1, 40) 
    .print()
    ,
    newButton("wait-instr", "zu den Übungsaufgaben")
        .center()
        .print()
    ,
    newCanvas("empty canvas-3", 1, 40) 
    .print()
    ,
    getButton("wait-instr")
    .wait()
)

//Practice trials
Template("AE_practice_items_8.1.csv", row =>
    newTrial("practice-SPR",
    newText("practice-h", "<h2>Übung<h2>")
    .print()
    ,
    newText("instructions", "Drücken Sie <b>Enter</b>, um mit dem Lesen des Satzes zu beginnen. Drücken Sie die <b>Leertaste</b>, um den nächsten Abschnitt anzuzeigen.")
    .print()
    .center()
    ,
    newKey("keypress", "Enter") 
        .log()
        .wait()
        .center()
        ,
    getText("instructions")
        .remove()
    ,
    newController("DashedSentence",  {s : row.Sentence.split("~")
    , display: "in place"
    }) 
        .center()
        .print()
        .log()
        .wait(200)
        .remove()
        ,
    newController("Question",  {q : row.question
        , as: [row.answer1,row.answer2] 
        , showNumbers: true 
        , randomOrder: true
        , hasCorrect: true // answer1 correct for all items
    }) 
        .center()
        .print()
        .log()
        .wait()
    )
    .log("trial_type", row.Trial_type)
    .log("condition", row.Condition)
)

// transition from practice to experiment
newTrial("transition-SPR",
    defaultText
        .print()
    ,
    newText("transition-SPR-1", "Das waren die Übungsdurchgänge. Klicken Sie auf <b>Start</b>, um das eigentliche Experiment zu beginnen.")
    ,
    newButton("wait-SPR", "Start")
        .center()
        .print()
        .wait()
)

// Experiment trials without attention checks
Template("AE_plain_A.csv", row =>
    newTrial("SPR-trial-plain"
    ,
    defaultText.center().print()
    ,
    newText("instructions", "Drücken Sie <b>Enter</b>, um mit dem Lesen des nächsten Satzes zu beginnen.")
        .print()
    ,
    newKey("keypress", "Enter") 
        .log()
        .wait()
        .center()
        ,
    getText("instructions")
        .remove()
    ,
    newController("DashedSentence",  {s : row.Sentence.split("~")
    , display: "in place"
    }) 
        .center()
        .print()
        .log()
        .wait(200)
        .remove()
        ,
    )
    .log("item", row.Item_name)
    .log("group", row.Group)
    .log("trial-type", row.Trial_type)
    .log("repetition", row.Repetition)
    .log("set", row.Sets)
    .log("condition", row.Condition)
    .log("modal-type", row.Modal_type_2)
    .log("lex-type", row.Lex_type)
)

// Experiment trials with attention checks
Template("AE_attention_A.csv", row =>
    newTrial("SPR-trial-attention"
    ,
    defaultText.center().print()
    ,
    newText("instructions", "Drücken Sie <b>Enter</b>, um mit dem Lesen des Satzes zu beginnen.")
        .print()
    ,
    newKey("keypress", "Enter") // in case we want to continue with spacebar
        .log()
        .wait()
        .center()
        ,
    getText("instructions")
        .remove()
    ,
    newController("DashedSentence",  {s : row.Sentence.split("~")
    , display: "in place"
    }) 
        .center()
        .print()
        .log()
        .wait(200)
        .remove()
        ,
    newController("Question",  {q : row.question
        , as: [row.answer1,row.answer2]
        , showNumbers: true 
        , randomOrder: true
        , hasCorrect: true 
    }) 
        .center()
        .print()
        .log()
        .wait()
    )
    .log("item", row.Item_name)
    .log("group", row.Group)
    .log("trial-type", row.Trial_type)
    .log("repetition", row.Repetition)
    .log("set", row.Sets)
    .log("condition", row.Condition)
    .log("modal-type", row.Modal_type_2)
    .log("lex-type", row.Lex_type)
)

//Debriefing / background information
newTrial("Background-language",
    newText("text-BG", "<b>Vielen Dank für die Bearbeitung!</b> Zum Schluss möchten wir noch einige Informationen zu Ihrem Hintergrund erfassen. Diese Informationen sind hilfreich für uns, um eventuelle Unterschiede zwischen Sprecher*innen besser zu verstehen.")
    .print()
    ,
    newText("h-languages", "<h3>Sprachenprofil </h3>")
    .print()
    ,
    newText("<p>Sprechen Sie, nach eigener Einschätzung, einen bestimmten Dialekt des Deutschen?</p>")
    .print()
    ,
    newDropDown("dialect-choice", " ")
            .add("ja", "nein")
            .print()
            .log()
    ,
    newText("<p>Falls 'ja', welchen Dialekt sprechen Sie?</p>")
    .print()
    ,
    newTextInput("dialect-free", " ")
    .log()
    .lines(0)
    .size(400, 30)
    .print()
    ,
    newCanvas("empty canvas-language", 1, 40) 
    .print()
    ,
newButton("send-BG-language", "Weiter")
    .print()
    , 
    newCanvas("empty canvas-language2", 1, 40) 
    .print()
    ,
    getButton("send-BG-language")
    .wait()
).setOption("countsForProgressBar",false)

newTrial("Background-demographic",
    newText("h-demographic", "<h3>Demografische Daten </h3>")
    .print()
    ,
    newText("text-gender", "<p>Welchem Geschlecht ordnen Sie sich zu?</p>")
    .print()
    ,
    newDropDown("sex", "Geschlecht")
            .add("weiblich", "männlich", "divers")
            .print()
            .log()
    ,
    newText("text-age", "<p>Wie alt Sind Sie?</p>")
    .print()
    ,
    newDropDown("age", "Alter")
            .add("18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "80", "älter als 80")
            .print()
            .log()
    ,
    newText("h-commentary", "<h3>Weitere Kommentare</h3>")
    .print()
    ,
    newText("t-feedback", "<p>In dieses Kästchen können Sie (optional) noch zusätzliche Kommentare schreiben. Klicken Sie 'Weiter', um zum Ende des Experiments zu gelangen.</p>")
    .print()
    ,
    newTextInput("feedback", " ")
    .lines(0)
    .size(400, 100)
    .print()
    .log()
,
    newCanvas("empty canvas-demo", 1, 40) 
    .print()
    ,
    newButton("send-BG-demo", "Weiter")
    .print()
    ,
    newCanvas("empty canvas-demo2", 1, 40) 
    .print()
    ,
    getButton("send-BG-demo")
    .wait()
    ,
    newVar("feedback-text")
        .set(getTextInput("feedback"))
)

// Send results to the server
SendResults("send")

// Redirection to prolific website
 newTrial("prolific",
    newText("<p><b>Vielen Dank für Ihre Teilnahme!</b></p>")
        .center()
        .print()
    ,
    newText("<p><a href='https://app.prolific.com/submissions/complete?cc=CRQEWCTD'"+ GetURLParameter("id")+"' target='_blank'>Klicken Sie hier, um Ihre Teilnahme auf Prolific zu bestätigen.</a></p> <p>Dieser Schritt ist notwendig, um Ihre Vergütung zu bekommen!</p>")
        .center()
        .print()
    ,
    newButton("void")
        .wait()
    )
