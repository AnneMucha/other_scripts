PennController.ResetPrefix(null)

Header(
   // void
)
.log( "PROLIFIC_ID" , GetURLParameter("id") )

//DebugOff() //only for publishing


Sequence("introduction", "data","consent","commitment", "instructions", "practice-context","practice1","practice2",
"practice3","transition",
// Football block
    "football-context","football-modal","football-quant","football-control",
// Friends block
"friends-context","friends-modal","friends-quant","friends-control",
// Neighbours block
"neighbours-context","neighbours-modal","neighbours-quant","neighbours-control",
"send", "prolific")


// Instructions
newTrial("introduction",
    defaultText
        //.center()
        .print()
    ,
    newText("header-1", "<h2> Thank you for participating in our study. </h2>")
    ,
    newText("text-4", "In this short experiment, we study the communicative preferences of English native speakers. The study will take about 5 minutes to complete.")
    ,
    newCanvas("canvas", 1, 40) //add some space below the Continue button
    .print()
    ,
    newButton("wait-intro", "Continue")
        .center()
        .print()
        ,
    newCanvas("empty canvas", 1, 40) 
    .print()
    ,
    getButton("wait-intro")
    .wait()
)

// Data handling
newTrial("data",
    defaultText
    .print()
    ,
    newText("h1", "<h2>Data protection statement</h2>")
    ,
    newText("data-1", "<b>Confidentiality and use of data.</b> All the information we collect during the course of the research will be processed in accordance with Data Protection Law. In order to safeguard your privacy, we will never share personal information (like your name) with anyone outside the research team. Your data will be referred to by a unique participant number rather than by name. Please note that we will temporarily collect your worker ID to prevent repeat participation, however we will never share this information with anyone outside the research team. We will store any personal data using the University of Edinburgh’s secure encrypted storage service. The anonymised data collected during this study will be used for research purposes and will be stored in a publicly accessible data repository (Edinburgh DataShare).")
    ,
    newText("data-2", "<p> </p> <b>What are my data protection rights?</b> The University of Edinburgh is a Data Controller for the information you provide. You have the right to access information held about you. Your right of access can be exercised in accordance with Data Protection Law. You also have other rights including rights of correction, erasure and objection. For more details, including the right to lodge a complaint with the Information Commissioner’s Office, please visit <a href= 'https://ico.org.uk/'>www.ico.org.uk</a>. Questions, comments and requests about your personal data can also be sent to the University Data Protection Officer at <a href='mailto:dpo@ed.ac.uk'>dpo@ed.ac.uk</a>.")
    ,
    newText("data-3", "<p> </p> <b>Voluntary participation and right to withdraw.</b> Your participation is voluntary, and you may withdraw from the study for any reason at any time during your participation, or within 1 month of completion. If you withdraw from the study during or after data gathering, we will delete your data and there is no penalty or loss of benefits to which you are otherwise entitled.")
    ,
    newText("data-4", "<p> </p> If you have any questions about what you’ve just read, please feel free to ask, or contact us later. This project has been approved by the PPLS Ethics committee. <p> </p>")
    ,
    newButton("wait-data", "Continue to consent")
        .center()
        .print()
        ,
    newCanvas("empty canvas-2", 1, 40) 
    .print()
    ,
    getButton("wait-data")
    .wait()
)
    newTrial("consent",
        defaultText
        .print()
    ,
    newText("data-5", "<p> </p> By proceedings with this experiment, you consent to the following:")
    ,
    newText("data-6", "<p> </p> <li> I agree to participate in this study. </li>")
    ,
    newText("data-7", "<li>I confirm that I have read and understood how my data will be stored and used. </li>")
    ,
    newText("data-8", "<li>I understand that I have the right to terminate this session at any point. If I choose to withdraw after completing the study, my data will be deleted at that time. </li> <p> </p>")
    ,
    newButton("wait-consent", "Consent and continue")
        .center()
        .print()
        .wait()
)

newTrial("commitment",
    newText("commit-1", "<h2> Commitment </h2>")
    .print()
    ,
    newText("commit-2", "The quality of our data is important to us. In order for us to draw accurate conclusions from the study results, we rely on you to complete the tasks in this experiment carefully and conscientiously.")
    .print()
    ,
    newText("<p>Do you agree to complete the tasks in this experiment carefully and conscientiously?</p>")
    .bold()
    .print()
    ,
    newScale("response", " Yes ", " No ")
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
    newButton("continue", "Thank you! Continue to instructions")
       .center()
    ,
    // If 'No' is selected, show a message and abort the experiment
    newText("abort-message", "Unfortunately, you cannot participate in the experiment. Please close the page.")
        .color("red")
        .bold()
        .center()
        ,
    getScale("response").wait() 
            .test.selected(" Yes ")
            .success( getButton("continue").print())
            .failure( getText("abort-message").print() ) 
    ,
    // Wait for the "Continue" button to be clicked 
    getButton("continue").wait()
)


// Instructions
newTrial("instructions",
    defaultText
        .print()
    ,
    newText("accept-1", "<h2>Instructions</h2>")
    ,
    newText("accept-2", "In this experiment, we present you with excerpts from a phone conversation between two friends, Bobby and Jo. Jo has an unstable connection, so in the relevant parts of the conversation, Bobby cannot properly hear what Jo is saying. On each page, we show you what Bobby said to Jo. <b>Your task is to decide what Jo replied</b>.")
    ,
    newText("accept-3","<p>You will see three possible responses. Please read all three options and then <b>select Jo's response by clicking on it</b>. There are no hidden clues, so don’t overthink it. Pick spontaneously the answer that you might have given if you were Jo.</p>")
    ,
    newText("accept-4", "In the main experiment, we will show you three different parts of the conversation, each with three exchanges between Bobby and Jo. Let's do a practice run so you can familiarise yourself with the task.")
    ,
    newCanvas("empty canvas-instr-acc", 1, 20) 
    .print()
    ,
    newButton("wait-instr2", "Continue to practice")
        .center()
        .print()
    ,
    newCanvas("empty canvas-instr-acc2", 1, 40) 
    .print()
    ,
    getButton("wait-instr2")
    .wait()
)
//practice 
newTrial("practice-context",
  newText("header-practice", "<h3>Practice</h3>")
  .print()
  ,
  newText("context-practice","Bobby and Joe both like animals, so when they talk on the phone, they always chat about animals for a bit. But this time, whenever Bobby brings up an animal, he can’t understand Jo’s reply. What do you think Jo said?")
  .print()
  ,
  newCanvas("empty canvas-pr", 1, 40) 
    .print()
    ,
    newButton("wait-pr", "Continue to dialogue")
        .center()
        .print()
    ,
    newCanvas("empty canvas-pr2", 1, 40) 
    .print()
    ,
    getButton("wait-pr")
    .wait()
)
  
  newTrial("practice1",
  defaultText
  .cssContainer({"margin-bottom":"1.5em"})
  .print()
  ,
  newText("pr-instr", "<b>Click on Jo's response.</b>")
  ,
  newText("<i>Bobby:</i> Reptiles are a bit ugly, but they are also really cool.")
  ,
  newText("<i>Jo:</i>")
  ,
  newText("snakes", "I know, snakes smell with their tongues!")
  ,
  newText("lizards", "I know, some lizards can reproduce without males!")
  ,
  newText("turtles", "I know, turtles have existed for over 200 million years!")
  ,
  newSelector("choice-practice1")
   .add( getText("snakes") , getText("lizards") , getText("turtles") )
   .frame()                       
   .shuffle()
   .log()
   .wait()
)
.log()

newTrial("practice2",
  defaultText
  .cssContainer({"margin-bottom":"1.5em"})
  .print()
  ,
  newText("pr-instr2", "<b>Click on Jo's response.</b>")
  ,
  newText("<i>Bobby:</i> Fish are kind of boring. Although I do love whales!")
  ,
  newText("<i>Jo:</i>")
  ,
  newText("nex-lex", "Sure, but no whale is a fish.")
  ,
  newText("nex-comp", "Sure, but every whale is not a fish.")
  ,
  newText("nuni", "Sure, but not every whale is a fish.")
  ,
  newSelector("choice-practice2")
   .add( getText("nex-lex") , getText("nex-comp") , getText("nuni") )
   .frame()                       
   .shuffle()
   .log()
   .wait()
)
.log()

newTrial("practice3",
   defaultText
  .cssContainer({"margin-bottom":"1.5em"})
  .print()
  ,
  newText("pr-instr3", "<b>Click on Jo's response.</b>")
  .print()
  ,
  newText("<i>Bobby:</i> Everybody knows that. Do you know anything else about whales?")
  .print()
  ,
  newText("<i>Jo:</i>")
  .print()
  ,
  newText("1", "Yes, blue whales are the largest animals ever.")
    .print()
  ,
  newText("2", "Yes, whales smell with their tongues.")
    .print()
  ,
  newText("3", "Yes, blue whales are the largest fish on earth.")
    .print()
  ,
  newSelector("choice-practice3")
   .add( getText("1") , getText("2") , getText("3") )
   .frame()                       
   .shuffle()
   .log()
   .wait()
)
.log()

// transition from practice to experiment
newTrial("transition",
    defaultText
        .center()
        .print()
    ,
    newText("transition-accept-1", "That was the practice run. Please click <b>continue</b> to start the experiment.")
    ,
    newCanvas("empty canvas", 1, 40)
    .print()
    ,
    newButton("wait-accept", "continue")
        .center()
        .print()
        .wait()
)

// trials 

newTrial("football-context",
  newText("header-fb", "<h3>Context</h3>")
  .print()
  ,
  newText("context-fb","Bobby and Jo both support their local football team. Bobby talks about his favourite players, and Jo has something to say about all of them. Unfortunately, Bobby can't understand. What do you think Jo said?")
  .print()
  ,
  newCanvas("empty canvas-fb", 1, 40) 
    .print()
    ,
    newButton("wait-fb", "Continue to dialogue")
        .center()
        .print()
    ,
    newCanvas("empty canvas-fb", 1, 40) 
    .print()
    ,
    getButton("wait-fb")
    .wait()
)

newTrial("football-modal",
   defaultText
  .cssContainer({"margin-bottom":"1.5em"})
  .print()
  ,
  newText("fb-instr", "<b>Click on Jo's response.</b>")
  .print()
  ,
  newText("<i>Bobby:</i> Leo is one of my favourite players!")
  .print()
  ,
  newText("<i>Jo:</i>")
  .print()
  ,
  newText("deontic", "Well... he is suspended, so he is not allowed to play this week.")
    .print()
  ,
  newText("epist", "Well... he is on vacation, so it's impossible that he is playing this week.")
    .print()
  ,
  newText("abil", "Well... he is injured, so he is not able to play this week.")
    .print()
  ,
  newSelector("choice-fb-mod")
   .add( getText("deontic") , getText("epist") , getText("abil") )
   .frame()                       
   .shuffle()
   .log()
   .wait()
)
.log()

newTrial("football-quant",
   defaultText
  .cssContainer({"margin-bottom":"1.5em"})
  .print()
  ,
  newText("fb-instr-qu", "<b>Click on Jo's response.</b>")
  .print()
  ,
  newText("<i>Bobby:</i> I also really like Christina. She is the only girl on the team.")
  .print()
  ,
  newText("<i>Jo:</i>")
  .print()
  ,
  newText("nex-comp", "She is also the only goalkeeper! Every boy on the team is not a goalie.")
    .print()
  ,
  newText("nex-lex", "She is also the only goalkeeper! No boy on the team is a goalie.")
    .print()
  ,
  newText("nuni", "She is also the only goalkeeper! Not every boy on the team is a goalie.")
    .print()
  ,
  newSelector("choice-fb-quant")
   .add( getText("nex-comp") , getText("nex-lex") , getText("nuni") )
   .frame()                       
   .shuffle()
   .log()
   .wait()
)
.log()

newTrial("football-control",
   defaultText
  .cssContainer({"margin-bottom":"1.5em"})
  .print()
  ,
  newText("fb-instr-co", "<b>Click on Jo's response.</b>")
  .print()
  ,
  newText("<i>Bobby:</i> And then there is also Jack. I heard that Jack is not feeling great about this week’s match, but I don’t know why.")
  .print()
  ,
  newText("<i>Jo:</i>")
  .print()
  ,
  newText("1", "He is sad because Leo is not playing.")
    .print()
  ,
  newText("2", "He is embarrassed because the girls on the team are better than him.")
    .print()
  ,
  newText("3", "He is angry because Christina is being benched for another goalkeeper.")
    .print()
  ,
  newSelector("choice-fb-control")
   .add( getText("1") , getText("2") , getText("3") )
   .frame()                       
   .shuffle()
   .log()
   .wait()
)
.log()

newTrial("friends-context",
  newText("header-friends", "<h3>Context</h3>")
  .print()
  ,
  newText("context-friends","Now, they talk about Jo's friends. Again, Bobby can't hear properly what Jo is saying about them.")
  .print()
  ,
  newCanvas("empty canvas-fr", 1, 40) 
    .print()
    ,
    newButton("wait-fr", "Continue to dialogue")
        .center()
        .print()
    ,
    newCanvas("empty canvas-fr", 1, 40) 
    .print()
    ,
    getButton("wait-fr")
    .wait()
)

newTrial("friends-quant",
   defaultText
  .cssContainer({"margin-bottom":"1.5em"})
  .print()
  ,
  newText("fr-instr-qu", "<b>Click on Jo's response.</b>")
  .print()
  ,
  newText("<i>Bobby:</i> How is Chris? Is he still on bad terms with his whole family?")
  .print()
  ,
  newText("<i>Jo:</i>")
  .print()
  ,
  newText("nex-comp", "Yes, everybody is not talking to him.")
    .print()
  ,
  newText("nex-lex", "Yes, nobody is talking to him.")
    .print()
  ,
  newText("nuni", "Yes, not everybody is talking to him.")
    .print()
  ,
  newSelector("choice-fr-quant")
   .add( getText("nex-comp") , getText("nex-lex") , getText("nuni") )
   .frame()                       
   .shuffle()
   .log()
   .wait()
)
.log()

newTrial("friends-modal",
   defaultText
  .cssContainer({"margin-bottom":"1.5em"})
  .print()
  ,
  newText("fr-instr", "<b>Click on Jo's response.</b>")
  .print()
  ,
  newText("<i>Bobby:</i> And how is Millie doing? I know she loves to travel, is she anywhere interesting right now?")
  .print()
  ,
  newText("<i>Jo:</i>")
  .print()
  ,
  newText("deontic", "Millie is a teacher and it's the school year, so she is not allowed to go on holiday right now.")
    .print()
  ,
  newText("epist", "Millie was at the office this morning, so it's impossible that she is on holiday right now.")
    .print()
  ,
  newText("abil", "Millie is broke and travelling is expensive, so she is not able to go on holiday right now.")
    .print()
  ,
  newSelector("choice-fr-mod")
   .add( getText("deontic") , getText("epist") , getText("abil") )
   .frame()                       
   .shuffle()
   .log()
   .wait()
)
.log()

newTrial("friends-control",
   defaultText
  .cssContainer({"margin-bottom":"1.5em"})
  .print()
  ,
  newText("fr-instr-co", "<b>Click on Jo's response.</b>")
  .print()
  ,
  newText("<i>Bobby:</i> And Louis? Is he doing well?")
  .print()
  ,
  newText("<i>Jo:</i>")
  .print()
  ,
  newText("1", "Yes, Louis is hanging out with Millie and her family a lot.")
    .print()
  ,
  newText("2", "Yes, Louis is hanging out with Chris and his family a lot.")
    .print()
  ,
  newText("3", "Yes, Louis is on holiday with Millie right now.")
    .print()
  ,
  newSelector("choice-fr-control")
   .add( getText("1") , getText("2") , getText("3") )
   .frame()                       
   .shuffle()
   .log()
   .wait()
)
.log()

newTrial("neighbours-context",
  newText("header-friends", "<h3>Context</h3>")
  .print()
  ,
  newText("context-n","Bobby asks about Jo's neighbours. What do you think Jo says about them?")
  .print()
  ,
  newCanvas("empty canvas-n", 1, 40) 
    .print()
    ,
    newButton("wait-n", "Continue to dialogue")
        .center()
        .print()
    ,
    newCanvas("empty canvas-n", 1, 40) 
    .print()
    ,
    getButton("wait-n")
    .wait()
)

newTrial("neighbours-modal",
   defaultText
  .cssContainer({"margin-bottom":"1.5em"})
  .print()
  ,
  newText("n-instr", "<b>Click on Jo's response.</b>")
  .print()
  ,
  newText("<i>Bobby:</i> Any news from Mr. Smith from next door? You said he was thinking about getting a puppy?")
  .print()
  ,
  newText("<i>Jo:</i>")
  .print()
  ,
  newText("deontic", "Actually, pets are forbidden in our tenement, so he is not allowed to raise a puppy.")
    .print()
  ,
  newText("epist", "Actually, I haven't heard any barking, so it's impossible that he is raising a puppy.")
    .print()
  ,
  newText("abil", "Actually, he has a terrible allergy, so he is not able to raise a puppy.")
    .print()
  ,
  newSelector("choice-n-mod")
   .add( getText("deontic") , getText("epist") , getText("abil") )
   .frame()                       
   .shuffle()
   .log()
   .wait()
)
.log()

newTrial("neighbours-quant",
   defaultText
  .cssContainer({"margin-bottom":"1.5em"})
  .print()
  ,
  newText("n-instr-qu", "<b>Click on Jo's response.</b>")
  .print()
  ,
  newText("<i>Bobby:</i> And your upstairs neighbours, are they going ahead with the lawsuit against the landlord?")
  .print()
  ,
  newText("<i>Jo:</i>")
  .print()
  ,
  newText("nex-comp", "No, because everybody does not agree with their complaints.")
    .print()
  ,
  newText("nex-lex", "No, because nobody agrees with their complaints.")
    .print()
  ,
  newText("nuni", "No, because not everybody agrees with their complaints.")
    .print()
  ,
  newSelector("choice-n-quant")
   .add( getText("nex-comp") , getText("nex-lex") , getText("nuni") )
   .frame()                       
   .shuffle()
   .log()
   .wait()
)
.log()

newTrial("neighbours-control",
   defaultText
  .cssContainer({"margin-bottom":"1.5em"})
  .print()
  ,
  newText("n-instr-co", "<b>Click on Jo's response.</b>")
  .print()
  ,
  newText("<i>Bobby:</i> I see, I guess you have to give landlords some credit. They are people, too.")
  .print()
  ,
  newText("<i>Jo:</i>")
  .print()
  ,
  newText("1", "Right, ours is not so bad.")
    .print()
  ,
  newText("2", "Right, too bad that my upstairs neighbours are suing him.")
    .print()
  ,
  newText("3", "Right, but I'm still glad I don't have one.")
    .print()
  ,
  newSelector("choice-fr-control")
   .add( getText("1") , getText("2") , getText("3") )
   .frame()                       
   .shuffle()
   .log()
   .wait()
)
.log()

// Send results manually
SendResults("send")

 newTrial("prolific",
 defaultText
  .cssContainer({"margin-bottom":"1.5em"})
  .center()
  .print()
  ,
    newText("<b>Thank you for participating!</b>")
    ,
    newText("<p><a href='https://app.prolific.com/submissions/complete?cc=CODE'"+ GetURLParameter("id")+"' target='_blank'>Please click here to confirm your participation on Prolific and receive your compensation.</a></p>")
    ,
    newButton("void")
        .wait()
    )


        
