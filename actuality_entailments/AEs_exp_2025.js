PennController.ResetPrefix(null); // Shorten command names 

Header(
   newVar("ID").global() 
)
.log( "ID" , GetURLParameter("id") ) // get URL from Prolific

DebugOff()   // Uncomment this line for publication

Sequence("introduction", "consent", "commitment", "instructions", "practice-SPR", "transition-SPR", rshuffle(randomize("SPR-trial-plain"), randomize("SPR-trial-attention")),"instructions-accept","practice-accept","transition-accept", rshuffle(randomize("plain-accept"), randomize("attention-accept")), "Background-language", "Background-demographic", "send", "prolific")

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
    newText("text-4", "<b>Die Studie besteht aus zwei Teilen und wird insgesamt etwa 30 Minuten in Anspruch nehmen. Bevor Sie mit der Bearbeitung anfangen, möchten wir Sie über den Ablauf informieren.</b>")
    ,
    newText("text-5","<li> Als Erstes klären wir Sie über die Verarbeitung Ihrer Daten auf.</li>")
    ,
    newText("text-6","<li> Vor der Bearbeitung der Aufgaben geben wir Ihnen jeweils eine kurze Anleitung.</li>")
    ,
    newText("text-7", "<li> Sie durchlaufen zwei Übungsdurchgänge, um sich mit der Aufgabe vertraut zu machen. Dann beginnt das eigentliche Experiment.</li>")
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
    newCanvas("empty canvas", 1, 40) //add some space below Continue button
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
    newText("commit-1", "<h2> Selbstverpflichtung </h2>")
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
       .center()
    ,
    // If 'No' or 'Not sure' are selected, show a message and abort the experiment
    newText("abort-message", "Sie können leider nicht an dem Experiment teilnehmen. Bitte schließen Sie die Seite.")
        .color("red")
        .bold()
        .center()
        ,
    getScale("response").wait() // Wait for the participant to select an option
        .test.selected(" Ja ")
        .success( getButton("continue").print())
        .failure( getText("abort-message").print() ) 
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
    newText("t-spr-1", "Beim ersten Teil dieser Studie handelt es sich um ein so genanntes 'self-paced reading'-Experiment.")
    ,
    newText("t-spr-2", "Dabei präsentieren wir Ihnen einzelne Sätze abschnittsweise und bitten Sie, diese in ihrem eigenen Tempo zu lesen.")
    ,
    newText("t-spr-4", "<p>In jedem Durchgang sehen Sie auf dem Bildschirm zunächst nur einen Strich. Jedes Mal, wenn Sie die <b>Leertaste</b> drücken, wird ein neuer Abschnitt angezeigt.</p>")
    ,
    newText("t-spr-6", "Ihre Aufgabe ist es, Testsätze zu lesen, indem Sie die Leertaste drücken, um den jeweils folgenden Abschnitt aufzudecken. Versuchen Sie bitte, in ihrem normalen Lesetempo zu lesen. Sie können sich so viel Zeit nehmen, wie Sie für das Lesen jedes Abschnitts benötigen, sollten aber unnötig lange Pausen vermeiden.")
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
    newController("DashedSentence",  {s : row.Sentence.split("~") // regions for SPR separated by "~"
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
Template("AE_plain_A_revised.csv", row =>
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
Template("AE_attention_A_revised.csv", row =>
    newTrial("SPR-trial-attention"
    ,
    defaultText.center().print()
    ,
    newText("instructions", "Drücken Sie <b>Enter</b>, um mit dem Lesen des Satzes zu beginnen.")
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

// instructions for the acceptability part
newTrial("instructions-accept",
    defaultText
        .print()
        ,
    newText("accept-0", "<b>Das war der erste Teil der Studie!</b>")
    ,
    newText("accept-1", "<h2>Anleitung zum zweiten Teil</h2>")
    ,
    newText("accept-2", "Im zweiten Teil der Studie bitten wir sie um Ihr muttersprachliches Urteil zur Natürlichkeit der gezeigten Satzabfolgen.")
    ,
    newText("accept-3","<p>Ihre Aufgabe ist, die Testsätze nochmals aufmerksam durchzulesen und auf einer Skala von 1 bis 7 zu bewerten, <b>wie natürlich der zweite Satz als Fortsetzung des ersten Satzes klingt</b>, wenn die beiden Sätze aufeinander folgend geäußert werden.</p>") 
    ,
    newText("accept-3.1", "Der Wert '1' auf der Skala bedeutet, der zweite Satz klingt als Fortsetzung des ersten Satzes überhaupt nicht natürlich. '7' bedeutet, der zweite Satz klingt als Fortsetzung des ersten Satzes vollkommen natürlich und angemessen. Die Zahlen 2-6 repräsentieren Nuancen zwischen 'gar nicht natürlich' und 'vollkommen natürlich'.")
    ,
    newText("accept-3.2", "<p>Dabei ist es wichtig, dass Sie die Sätze als zusammenhängende Äußerung bewerten. Nehmen wir als Beispiel die folgenden beiden Satzpaare:</p>")
    ,
    newText("accept-3.3", "Satzpaar 1: <i>Franz ist heute 2 km geschwommen. Helga ist sogar 3 km geschwommen.</i>")
    ,
    newText("accept-3x", "<p>In Satzpaar 1 klingt der zweite Satz vollkommen natürlich und angemessen als Fortsetzung des ersten Satzes und sollte daher einen hohen Wert auf der Skala bekommen (z.B. 7).</p>")
    ,
    newText("accept-3.4", "Satzpaar 2: <i>Franz ist heute 4 km geschwommen. Helga ist sogar 3 km geschwommen.</i>")
    ,
    newText("accept-3.5", "<p>Der zweite Satz in Satzpaar 2 ist identisch mit dem in Satzpaar 1. In diesem Fall aber klingt er nicht so natürlich und angemessen als Fortsetzung des ersten Satzes. Deswegen sollte hier ein niedrigerer Wert auf der Skala gewählt werden.</p>")
    ,
    newText("accept-4", "Bei dieser Aufgabe gibt es keine richtigen oder falschen Antworten. Verlassen Sie sich einfach auf Ihr eigenes Urteil und fragen Sie bitte niemand anderen nach einer zweiten Meinung.")
    ,
    newText("accept-5", "<p>Sie können eine Zahl auf der Skala durch Anklicken auswählen oder die entsprechende Taste auf Ihrer Tastatur drücken. Sie haben außerdem die Möglichkeit, Kommentare zu einzelnen Beispielen in ein Kommentarfeld zu schreiben. (Das Kommentarfeld kann aber auch leer bleiben.)</p>")
    ,
    newText("accept-6", "Zunächst können Sie sich wieder in zwei Übungsdurchgängen mit der Aufgabe vertraut machen.</p>")
    ,
    newCanvas("empty canvas-instr-acc", 1, 20) 
    .print()
    ,
    newButton("wait-instr2", "zu den Übungsaufgaben")
        .center()
        .print()
    ,
    newCanvas("empty canvas-instr-acc2", 1, 40) 
    .print()
    ,
    getButton("wait-instr2")
    .wait()
)

//practice rating
Template("AE_practice_items_8.1.csv", row =>
    newTrial("practice-accept",
    newText("practice-question", "<h4>Wie natürlich klingt der zweite Satz als Fortsetzung des ersten Satzes?</h4>" + "<p> </p>" )
            .center()
            .print()
        ,
        newText("practice-modal", row.Sentence1.replaceAll("~"," ") + "<p> </p>") // remove "~" from items for acceptability task
            .center()
            .print()
        ,
        newController("AcceptabilityJudgment",  {s : row.Sentence2.replaceAll("~"," ")
        , presentAsScale: true
        , as: [["1", "1"], ["2", "2"], ["3", "3"], ["4", "4"], ["5", "5"], ["6", "6"], ["7", "7"]]
        , showNumbers: true 
        , randomOrder: false
        , leftComment: "gar nicht<br> natürlich"
        , rightComment: "vollkommen<br> natürlich"
    }) 
        .center()
        .print()
        .log()
        .wait()
        ,
    newCanvas("prac-empty canvas-comment0", 1, 40) 
    .print()
    ,
    newText("prac-text-comment", "<p>Kommentar (optional)</p>")
    .center()
    .print()
    ,
    newTextInput("prac-comment", " ")
    .lines(0)
    .size(200, 80)
    .center()
    .print()
    .log()
    ,
    newCanvas("prac-empty canvas-comment", 1, 40) 
    .print()
    ,
    newButton("prac-send-BG-comment", "weiter")
    .center()
    .print()
    ,
    newCanvas("prac-empty canvas-comment2", 1, 40) 
    .print()
    ,
    getButton("prac-send-BG-comment")
    .wait()
    ,
    newVar("prac-comment-text")
        .set(getTextInput("prac-comment"))
    )
    .log("trial-type", row.Trial_type)
)

// transition from practice to experiment
newTrial("transition-accept",
    defaultText
        .center()
        .print()
    ,
    newText("transition-accept-1", "Das waren die Übungsdurchgänge. Klicken Sie auf <b>weiter</b>, um fortzufahren.")
    ,
    newCanvas("empty canvas", 1, 40)
    .print()
    ,
    newButton("wait-accept", "weiter")
        .center()
        .print()
        .wait()
)

//rating plain
Template("AE_plain_A_revised.csv", row =>
    newTrial("plain-accept",
    newText("plain-question", "<h4>Wie natürlich klingt der zweite Satz als Fortsetzung des ersten Satzes?</h4>" + "<p> </p>" )
            .center()
            .print()
        ,
        newText("practice-modal", row.Sentence1.replaceAll("~"," ") + "<p> </p>")
           .center()
            .print()
        ,
        newController("AcceptabilityJudgment",  {s : row.Sentence2.replaceAll("~"," ")
        , presentAsScale: true
        , as: [["1", "1"], ["2", "2"], ["3", "3"], ["4", "4"], ["5", "5"], ["6", "6"], ["7", "7"]]
        , showNumbers: true 
        , randomOrder: false
        , leftComment: "gar nicht<br> natürlich"
        , rightComment: "vollkommen<br> natürlich"
    }) 
        .center()
        .print()
        .log()
        .wait()
        ,
        newCanvas("acc-empty canvas-comment0", 1, 40) 
    .print()
    ,
    newText("acc-text-comment", "<p>Kommentar (optional)</p>")
    .center()
    .print()
    ,
    newTextInput("acc-comment", " ")
    .lines(0)
    .size(200, 80)
    .center()
    .print()
    .log()
    ,
    newCanvas("acc-empty canvas-comment", 1, 40) 
    .print()
    ,
    newButton("acc-send-BG-comment", "weiter")
    .center()
    .print()
    ,
    newCanvas("acc-empty canvas-comment2", 1, 40) 
    .print()
    ,
    getButton("acc-send-BG-comment")
    .wait()
    ,
    newVar("acc-comment-text")
        .set(getTextInput("acc-comment"))
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

//rating plain
Template("AE_attention_A_revised.csv", row =>
    newTrial("attention-accept",
    newText("attention-question", "<h4>Wie natürlich klingt der zweite Satz als Fortsetzung des ersten Satzes?</h4>" + "<p> </p>" )
            .center()
            .print()
        ,
        newText("practice-modal", row.Sentence1.replaceAll("~"," ") + "<p> </p>")
           .center()
            .print()
        ,
        newController("AcceptabilityJudgment",  {s : row.Sentence2.replaceAll("~"," ")
        , presentAsScale: true
        , as: [["1", "1"], ["2", "2"], ["3", "3"], ["4", "4"], ["5", "5"], ["6", "6"], ["7", "7"]]
        , showNumbers: true 
        , randomOrder: false
        , leftComment: "gar nicht<br> natürlich"
        , rightComment: "vollkommen<br> natürlich"
    }) 
        .center()
        .print()
        .log()
        .wait()
        ,
    newCanvas("empty canvas-comment0", 1, 40) 
    .print()
    ,
    newText("text-comment", "<p>Kommentar (optional)</p>")
    .center()
    .print()
    ,
    newTextInput("comment", " ")
    .lines(0)
    .size(200, 80)
    .center()
    .print()
    .log()
    ,
    newCanvas("empty canvas-comment", 1, 40) 
    .print()
    ,
    newButton("send-BG-comment", "weiter")
    .center()
    .print()
    ,
    newCanvas("empty canvas-comment2", 1, 40) 
    .print()
    ,
    getButton("send-BG-comment")
    .wait()
    ,
    newVar("comment-text")
        .set(getTextInput("comment"))
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
    newText("<p><a href='https://app.prolific.com/submissions/complete?cc=CQ5MBTUP'"+ GetURLParameter("id")+"' target='_blank'>Klicken Sie hier, um Ihre Teilnahme auf Prolific zu bestätigen.</a></p> <p>Dieser Schritt ist notwendig, um Ihre Vergütung zu bekommen!</p>")
        .center()
        .print()
    ,
    newButton("void")
        .wait()
    )
