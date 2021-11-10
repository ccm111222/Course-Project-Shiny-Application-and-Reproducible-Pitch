
library(shiny)
shinyServer(function(input, output) {
    esoph_processed<-esoph
    esoph_processed$risk<-(esoph_processed$ncases/(esoph_processed$ncases+esoph_processed$ncontrols))
    esoph_processed$age<-as.numeric(substr(esoph_processed$agegp,start = 1,stop = 2))
    esoph_processed$alcohol[esoph_processed$alcgp=="0-39g/day"]=0
    esoph_processed$alcohol[esoph_processed$alcgp=="40-79"]=40
    esoph_processed$alcohol[esoph_processed$alcgp=="80-119"]=80
    esoph_processed$alcohol[esoph_processed$alcgp=="120+"]=120
    esoph_processed$tobacco[esoph_processed$tobgp=="0-9g/day"]=0
    esoph_processed$tobacco[esoph_processed$tobgp=="10-19"]=10
    esoph_processed$tobacco[esoph_processed$tobgp=="20-29"]=20
    esoph_processed$tobacco[esoph_processed$tobgp=="30+"]=30
    fit<-lm(risk~age+alcohol+tobacco, data=esoph_processed)
    
    model_predict <- reactive({
        data1<-data.frame(age=input$age, alcohol=input$alcohol, tobacco=input$tobacco)
        predict(fit, newdata = data1, interval = "confidence")
    })
    
    output$pred1 <- renderText({
        model_predict()[1]
    })
    
    output$pred2 <- renderText({
        model_predict()[2]
    })
    
    output$pred3 <- renderText({
        model_predict()[3]
    })
    
    output$plot1 <- renderPlotly({
        library(plotly)
        data1<-data.frame(age=input$age, alcohol=input$alcohol, tobacco=input$tobacco)
        data2<-data.frame(age=input$age, alcohol=input$alcohol, tobacco=input$tobacco, 
                          risk=predict(fit, newdata = data1))
        fig <- plot_ly(data=esoph_processed, x=~age, y=~alcohol, z=~tobacco, 
                       type = "scatter3d", color = ~risk, name = "Original data", mode="markers")
        fig %>% add_trace(
            data=data2,
            x=~age, 
            y=~alcohol, 
            z=~tobacco,
            type = "scatter3d", 
            color = ~risk,
            marker=list(size=20),
            name="Your data",
            mode="markers"
        )
    })
})
