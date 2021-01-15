library(shiny) 
library(DT) 
library(plotly) 
library(crosstalk) 
library(tidyverse) 
library(knitr)
library(kableExtra)


ui <- fluidPage( 
  titlePanel("Learning Poverty - Country Simulation"),
 sidebarLayout(
  sidebarPanel(  img( src="https://user-images.githubusercontent.com/43160181/66895172-211fc400-efc0-11e9-998e-c5090e51730d.png", width="200", height="200", align="Center"),
                 h1(" Simulation"),
                 
                p(" This tool shows how much progress can be made reducing Learning Poverty over time under different growth scenarios.  
    Scenarios are presented where countries grow at their regional 50th, 60th, 70th, 80th, 90th, 95th, and 99th percentiles. 
    To learn more about Learning Poverty, view the World Bank topic page on the subject.     ", style = "font-size:20px"), 
                   a(href="https://www.worldbank.org/en/topic/education/brief/learning-poverty", "Learning Poverty Page", style = "font-size:20px"),
                h2("Start Simulation"),
                
                p("Click on the play button in the bottom right corner to launch the simulation and to see how quickly learning poverty can be reduced.. ", style = "font-size:20px"),
                
                 width = 2
  ),
  mainPanel(
  selectizeInput("country", "Select Countries",
                 choices=NULL,
                 selected=c("All"),
                 multiple=T),  
  plotlyOutput("x2", height = 800), 
  htmlOutput("x1", width='60%',) ,
  sliderInput("year", "Year", 
              min=2015, 
              max=2030, 
              step=1, 
              value=2015, 
              sep="", 
              width='100%',
              animate=
                animationOptions(interval = 800, loop = FALSE) ),
  includeMarkdown('lpov_desc.md'),      
  

  
  tags$head(tags$style(type='text/css', ".slider-animate-button { font-size: 20pt !important; }"))
  
  )
) 
)
server <- function(input, output, session) { 
  
  load(file = 'pref1005_p99_sim_numbers.RData') 
  
  #add country choices
  choice <- unique(as.character(tab_country1$countryname))
  choice<-append('All',choice)
  
  updateSelectizeInput(session, 'country', choices = choice, selected=c("All"), server=TRUE)
  
  
  #list of variables to keep 
  keep_list<-c("countrycode", "countryname", "region", "regionname", "adminregion", 
               "adminregionname", "incomelevel",  "incomelevelname") 
  
  
  tab_country <- reactive({
    if (!("All" %in% input$country))
    tab_country1 %>%
      filter(countryname %in% input$country) 
    else (
      tab_country1
    )
      
  })

  country_long <- reactive ({
    tab_country() %>% 
    filter(!is.na(learning_poverty2015r50)) %>% 
    select(keep_list, starts_with("learning_poverty"), starts_with("pop")) %>% 
    pivot_longer( #pivot population variables from wide to long 
      cols=starts_with('pop'), 
      names_to= "year_pop", 
      values_to = "population" 
    ) %>% 
    pivot_longer( #Pivot learning poverty from wide to long 
      cols=starts_with("learning_poverty"), 
      names_to = "type", 
      values_to = "learning_poverty" 
    ) %>% 
    mutate(year_pop=substring(year_pop, 5,9), 
           year=substring(type, nchar("learning_poverty")+1,nchar("learning_poverty")+4), 
           growth_type=substring(type, nchar("learning_poverty")+5,nchar("learning_poverty")+9)) %>% 
    filter(year_pop==year) %>%  #because we reshaped wide to long twice, need to remove duplicates  
    filter(substring(growth_type,1,1)=="r") %>% 
    mutate(growth_type=factor(growth_type, levels=c("r50", "r60", "r70", "r80", "r90", "r95", "r99"), 
                              labels=c("50th Percentile", 
                                       "60th Percentile", 
                                       "70th Percentile", 
                                       "80th Percentile", 
                                       "90th Percentile",
                                       "95th Percentile",
                                       "99th Percentile"))) 
  })
    
  global_pop <- reactive({
  #add in global population 
   tab1 %>% 
    filter(region!="Global") %>% 
    select(starts_with("pop_total")) %>% 
    summarise_all(~sum(.)) %>% 
    pivot_longer( #pivot population variables from wide to long 
      cols=starts_with('pop'), 
      names_to= "year", 
      values_to = "population_global" 
    ) %>% 
    mutate(year=substring(year, nchar(year)-3, nchar(year))) %>%
    filter(year==input$year) 
    
  })
  
  
  # create global number database too 
  global_long <- reactive({ 
    tab1 %>% 
    filter(region=="Global") %>% 
    select(region, starts_with("learning_poverty")) %>% 
    pivot_longer( #Pivot learning poverty from wide to long 
      cols=starts_with("learning_poverty"), 
      names_to = "type", 
      values_to = "learning_poverty_global" 
    ) %>% 
    mutate(year=substring(type, nchar("learning_poverty")+1,nchar("learning_poverty")+4), 
           growth_type=substring(type, nchar("learning_poverty")+5,nchar("learning_poverty")+9)) %>% 
    filter(substring(growth_type,1,1)=="r") %>% 
    mutate(growth_type=factor(growth_type, levels=c("r50", "r60", "r70", "r80", "r90", "r95", "r99"), 
                              labels=c("50th Percentile", 
                                       "60th Percentile", 
                                       "70th Percentile", 
                                       "80th Percentile", 
                                       "90th Percentile",
                                       "95th Percentile",
                                       "99th Percentile"))) %>% 
    select(growth_type, learning_poverty_global, year)  %>%
    filter(year==input$year) 
    
  
  })
  
  country_long_gl<- reactive({
    country_long() %>% 
    left_join(global_pop()) %>% 
    left_join(global_long())  
  
  })
  
  country_sim_df<- reactive( { 
    
    country_long_gl() %>% 
      filter(year==input$year) 
  }) 
  
  
  millions_df<- reactive( { 
    
    global_long() %>% 
      left_join(global_pop()) %>%
      filter(year==input$year) 
  }) 
  
  
  
  
  
  
  
  # highlight selected rows in the scatterplot 
  output$x2 <- renderPlotly({ 
    
    d_plot<-country_sim_df() %>%
      mutate(pop_pov=(learning_poverty_global/100)*population_global) 
      
    country_sim <-plot_ly(d_plot, 
                          x = ~growth_type,  
                          y =~learning_poverty, 
                          size = ~population, 
                          color = ~regionname, 
                          text = ~countryname, 
                          hovertemplate = paste( 
                            "<b>%{text}</b><br><br>", 
                            "%{yaxis.title.text}: %{y}<br>", 
                            "<extra></extra>" 
                          ), 
                          hoverinfo="text", 
                          type="scatter", 
                          mode = "markers", 
                          #Choosing the range of the bubbles' sizes: 
                          sizes = c(10, 50), 
                          marker = list(opacity = 0.5, sizemode = 'diameter') ) %>% 
      layout(title = 'Simulation of Learning Poverty Overtime by Country', 
             xaxis = list(title="Regional Growth Rate"), 
             yaxis = list(title="Learning Poverty", 
                          range=c(0,100)))  
    
    country_sim 
    
  }) 
  
  
  # highlight selected rows in the table 
  output$x1 <- renderText({ 
    
    country_long_gl_text <-  millions_df() %>% 
      mutate(pop_pov=(learning_poverty_global/100)*population_global) %>%
      select(year, growth_type, learning_poverty_global, population_global, pop_pov) %>%
      group_by(growth_type) %>% 
      summarise(pop_pov=round(mean(pop_pov),0)) %>%
      mutate(pop_pov= formatC(pop_pov, format = "f", big.mark = ",", drop0trailing = TRUE)) %>%
      pivot_wider(
                  names_from=growth_type,
                  values_from=c("pop_pov")) %>%
    mutate(Label=factor(row_number(), labels=c("Number of Children in Learning Poverty")))
      
    
    country_long_gl_text2 <-  millions_df() %>% 
      group_by(growth_type) %>% 
      summarise(learning_poverty_global=paste(round(mean(learning_poverty_global),1),"%", sep="")) %>%
      pivot_wider(
                  names_from=growth_type,
                  values_from=c("learning_poverty_global")) %>%
      mutate(Label=factor(row_number()+1, labels=c("Learning Poverty %")))
      
    
    country_long_gl_text <- country_long_gl_text %>%
      bind_rows(country_long_gl_text2) %>%
      select( Label, everything())
    
    kable(country_long_gl_text,
                        row.names = T,
                        caption="Glboal Number of Children in Learning Poverty Under Different Growth Scenarios",
                        format="html") %>%
      column_spec(1, width = "10em") %>%
      kable_styling(bootstrap_options = c("striped", "hover")) 
     
    
  }) 
  
  
  
} 

shinyApp(ui, server)