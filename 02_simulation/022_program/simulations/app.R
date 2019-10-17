

#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(RStata)
library(tidyr)
library(dplyr)
library(plotly)
library(glue)
library(DT)
library(rvg)
library(officer)

wrapper <- function(x, ...) 
{
  paste(strwrap(x, ...), collapse = "\n")
}


#Some RStata options
options("RStata.StataVersion" = 16)

if (file.exists("C:/Program Files/Stata16/StataMP-64.exe")) {
  stata_path = "\"C:\\Program Files\\Stata16\\StataMP-64\""
  options("RStata.StataPath"=stata_path)
} else {
  chooseStataBin()
  options("RStata.StataPath")
}
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Learning For All Simulation App"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      actionButton("gobutton", "Go!"),
      textInput("filename", "Name for final .dta sim file", value="mysimfile" ),
      textInput("directory", "Location of directory to save graphs or tables", value='C:/Users/WB469649/WBG/Joao Pedro Wagner De Azevedo - EduDataAnalytics/L4A_Paper/tables_for_excel/'),
      textInput("preference", "Name of preference from rawlatest", value="1005" ),  
      textInput("weight", "specify weights to be used ", value="aw=wgt" ),
      textInput("ifspell", "if statement in stata syntax to keep only these spell data", value='if delta_adj_pct > -2 & delta_adj_pct < 4 & year_assessment>2000  & lendingtype!="LNX"' ),
      textInput("ifsim", "if statement in stata syntax to keep only these obs in sim", value='if  lendingtype!="LNX"' ),
      textInput("ifwindow", "if statement in stata syntax to keep obs with these years in sim ", value="if assess_year>=2011" ),
      textInput("specialincludeassess", "Include any extra assessments in the spells database", value="PIRLS LLECE  TIMSS SACMEQ"),
      textInput("specialincludegrade", "Include any extra grades in the spells database", value="3 4 5 6"), 
      textInput("enrollment", "which enrollment variable to use", value="validated"), 
      textInput("usefile", "Name of Markdown file with Regional Growth Rates", value='"${clone}/02_simulation/022_program/special_simulation_spells_nopasec_weigthed_pref1005.md"'), 
      textInput("timss", "TIMSS:  Science or Math", value='science'), 
      textInput("population_2015", "Keep population fixed at 2015?", value='No'),
      textInput("savectryfile", "Save Country File with this name:", value='special_spells_nopasec_weigthed'),
      textInput("groupingsim", "Group by Regions (region), Initial Poverty Level (initial_poverty_level), or Income Level (incomelevel) for Simulation?", value='region'),
      textInput("groupingspells", "Group by Regions (region), Initial Poverty Level (initial_poverty_level), or Income Level (incomelevel) for calculating growth rates?", value='region'),
      textInput("growthdynamics", "If Grouping by Initial Poverty Level, make growth rates dynamic? (Yes or No)", value='Yes'),
      textInput('percentile', "Calculate special growth rates percentiles in spell file", value="50(10)90"),
      textInput('high_scenario', "Specify percentile for high growth scenario", value="r80")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      
      textOutput("sim_input"),
      actionButton("save_graph", "Save Global #'s Figure to Excel at directory entered"),
      plotlyOutput("sim_figures1"),
      actionButton("save_graph_regional", "Save Regional #'s Figure to Excel at directory entered"),
      plotlyOutput("sim_figures2"),
      DT::dataTableOutput("sim_spells"),
      DT::dataTableOutput("sim_output"),
      DT::dataTableOutput("sim_output_country")
      
      
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  observeEvent(input$gobutton, {
    stata_path = "\"C:\\Program Files (x86)\\Stata15\\StataMP-64\""
    
    
    #initialize the simulation ado file.  First, Run an initial do file to set the paths and load a few programs.  We write the _simulation_dataset,.. code using options inputed previously
    prog<-glue('
    do sim_prep.do
    _simulation_dataset, ifspell({input$ifspell}) ///
                    ifwindow({input$ifwindow}) ///
                    ifsim({input$ifsim} ) weight({input$weight})  preference({input$preference}) ///
                    specialincludeassess( {input$specialincludeassess} ) specialincludegrade({input$specialincludegrade}) ///
                    filename({input$filename}) ///
	                usefile({input$usefile}) ///
                    timss({input$timss}) enrollment({input$enrollment}) population_2015({input$population_2015}) ///
                    groupingsim({input$groupingsim}) groupingspells({input$groupingspells}) growthdynamics({input$growthdynamics}) ///
                    percentile({input$percentile})
                    ')
    
    #Execute stata code based on simulation parameters defined above    
    stata(c(prog) )
    
    #load data from sim
    df_path<-paste("C:/Users/",Sys.getenv("USERNAME"),"/Documents/Github/LearningPoverty/02_simulation/023_outputs/",input$filename ,"_sim_numbers.dta", sep="")
    df<-haven::read_dta(df_path)
    
    
    ######################################
    #Create ggplot of simulation over time
    ######################################
    output$sim_figures1 <- renderPlotly({
      if (input$groupingsim=="region") {
        
        var_list<-c("year", "region", "pop_total","pop_with_data", "pop_sim", "wgt_adjpro", "growth_type", "preference" )
        df_plot <- df %>%
          select_at(vars(var_list)) %>%
          mutate(learning_poverty=100-wgt_adjpro) %>%
          select(-wgt_adjpro) %>%
          tidyr::spread(key=growth_type, value=learning_poverty)
        
      }
      
      else if (input$groupingsim=="initial_poverty_level") {
        var_list<-c("year", "initial_poverty_level", "pop_total","pop_with_data", "pop_sim", "wgt_adjpro", "growth_type", "preference" )
        df_plot <- df %>%
          select_at(vars(var_list)) %>%
          mutate(learning_poverty=100-wgt_adjpro) %>%
          mutate(region=initial_poverty_level) %>%
          select(-wgt_adjpro) %>%
          tidyr::spread(key=growth_type, value=learning_poverty)        
        
        
      }
      else if (input$groupingsim=="incomelevel") {
        var_list<-c("year", "incomelevel", "pop_total","pop_with_data", "pop_sim", "wgt_adjpro", "growth_type", "preference" )
        df_plot <- df %>%
          select_at(vars(var_list)) %>%
          mutate(learning_poverty=100-wgt_adjpro) %>%
          mutate(region=incomelevel) %>%
          select(-wgt_adjpro) %>%
          tidyr::spread(key=growth_type, value=learning_poverty)        
        
        
      }       
      
      df_plot_global<- df_plot %>%
        filter(region=="Global")
      
      rgrp<-reactive({
        df_plot_global %>%
          select(input$high_scenario) %>%
          mutate(val=get(input$high_scenario))
      })
      
      
      df_plot_global %>%
        plot_ly(x= ~df_plot_global$year, y=~df_plot_global$r50, type="scatter", mode='lines+markers', name="Business as Usual"  ) %>%
        add_trace(x= ~df_plot_global$year, y=~rgrp()$val, line = list(widthh=0.5, dash="dot"), name=paste("High Scenario", input$high_scenario, sep=" ")  ) %>%
        layout(xaxis=list(title="Simulation of Global Learning Poverty"), yaxis=list(title="Learning Poverty"))
      
      
      
      
    })  
    
    observeEvent(input$save_graph, {
      
      if (input$groupingsim=="region") {
        
        var_list<-c("year", "region", "pop_total","pop_with_data", "pop_sim", "wgt_adjpro", "growth_type", "preference" )
        df_plot <- df %>%
          select_at(vars(var_list)) %>%
          mutate(learning_poverty=100-wgt_adjpro) %>%
          select(-wgt_adjpro) %>%
          tidyr::spread(key=growth_type, value=learning_poverty)
        
      }
      
      else if (input$groupingsim=="initial_poverty_level") {
        var_list<-c("year", "initial_poverty_level", "pop_total","pop_with_data", "pop_sim", "wgt_adjpro", "growth_type", "preference" )
        df_plot <- df %>%
          select_at(vars(var_list)) %>%
          mutate(learning_poverty=100-wgt_adjpro) %>%
          mutate(region=initial_poverty_level) %>%
          select(-wgt_adjpro) %>%
          tidyr::spread(key=growth_type, value=learning_poverty)        
        
        
      }
      else if (input$groupingsim=="incomelevel") {
        var_list<-c("year", "incomelevel", "pop_total","pop_with_data", "pop_sim", "wgt_adjpro", "growth_type", "preference" )
        df_plot <- df %>%
          select_at(vars(var_list)) %>%
          mutate(learning_poverty=100-wgt_adjpro) %>%
          mutate(region=incomelevel) %>%
          select(-wgt_adjpro) %>%
          tidyr::spread(key=growth_type, value=learning_poverty)        
        
        
      }       
      
      df_plot_global<- df_plot %>%
        filter(region=="Global")
      
      names<-colnames(df_plot_global[,grep("r5|r6|r7|r8|r9",colnames(df_plot_global))])
      
      df_plot_global_wide<- df_plot_global %>% 
        select(-c( 'pop_total', 'pop_with_data', 'pop_sim', 'preference')) %>%
        gather('own', names, key='type', value='pov') %>%
        spread(year, pov )
      
      write.csv(df_plot_global_wide, file=paste(input$directory,"figure4_data.csv", sep=""))
      
        
      baseline_val<-df_plot_global %>%
        filter(year==2015)
      
      baseline_val<-as.list(as.data.frame(baseline_val[,'r50']))
      
      slope<-(baseline_val$r50[1]/2-baseline_val$r50[1])/15
      intercept<-baseline_val$r50[1]
      
      p<-ggplot(df_plot_global, aes(x=year)) +
        geom_line(aes(y=r50, colour='r50')) +
        geom_point(aes(y=r50),colour="blue") +
        geom_line(aes(y=r80), colour='orange', linetype="dashed") +
        geom_point(aes(y=r80),colour="orange") +  
        #geom_segment(aes(x=2015, y=intercept, xend=2030, yend=(intercept+15*slope), colour='segment'), data=df_plot_global) +
        geom_hline(yintercept=intercept/2, colour='black') +
        scale_color_manual(name="Simulation", values = c('r50' = 'blue', 'r80'='orange',  'segment'='black'), labels=c(wrapper("Business as Usual", width=15), wrapper("High Scenario (r80)", width=15), wrapper('Track to Half Learning Poverty', width=15))) +
        labs(y="Learning Poverty", title="Simulation of Global Learning Poverty") +
        ylim(0,60) +
        theme_classic() 
      
      
      
      excl<-read_xlsx()
      excl<-xl_add_vg(excl, sheet="Feuil1", code = print(p), 
                      width = 6, height = 6, left = 1, top = 2 )
      print(excl, target=paste(input$directory,"figure4.xlsx", sep=""))
    })
    
    
    ###############################################
    #Create ggplot of simulation over time by group
    ###############################################
    output$sim_figures2 <- renderPlotly({
      if (input$groupingsim=="region") {
        
        var_list<-c("year", "region", "pop_total","pop_with_data", "pop_sim", "wgt_adjpro", "growth_type", "preference" )
        df_plot <- df %>%
          select_at(vars(var_list)) %>%
          mutate(learning_poverty=100-wgt_adjpro) %>%
          select(-wgt_adjpro) %>%
          tidyr::spread(key=growth_type, value=learning_poverty)
        
        
        
      }
      
      else if (input$groupingsim=="initial_poverty_level") {
        var_list<-c("year", "initial_poverty_level", "pop_total","pop_with_data", "pop_sim", "wgt_adjpro", "growth_type", "preference" )
        df_plot <- df %>%
          select_at(vars(var_list)) %>%
          mutate(learning_poverty=100-wgt_adjpro) %>%
          mutate(region=initial_poverty_level) %>%
          select(-wgt_adjpro) %>%
          tidyr::spread(key=growth_type, value=learning_poverty)        
        
        
      }
      else if (input$groupingsim=="incomelevel") {
        var_list<-c("year", "incomelevel", "pop_total","pop_with_data", "pop_sim", "wgt_adjpro", "growth_type", "preference" )
        df_plot <- df %>%
          select_at(vars(var_list)) %>%
          mutate(learning_poverty=100-wgt_adjpro) %>%
          mutate(region=incomelevel) %>%
          select(-wgt_adjpro) %>%
          tidyr::spread(key=growth_type, value=learning_poverty)        
        
        
      }     
      df_plot_regional<- df_plot %>%
        filter(region!="Global")     
      
      
      rgrp_reg<-reactive({
        df_plot_regional %>%
          select(input$high_scenario) %>%
          mutate(val=get(input$high_scenario))
      })
      
      
      df_plot_regional %>%
        plot_ly(x= ~df_plot_regional$year, y=~df_plot_regional$r50, type="scatter", mode='lines+markers',  color=~df_plot_regional$region  ) %>%
        add_trace(x= ~df_plot_regional$year, y=~rgrp_reg()$val, line = list(widthh=0.5, dash="dot", color=~df_plot_regional$region)     ) %>%
        layout(xaxis=list(title="Simulation of Regional Learning Poverty"), yaxis=list(title="Learning Poverty"))
      
    })
    
    observeEvent(input$save_graph_regional, {
      
      if (input$groupingsim=="region") {
        
        var_list<-c("year", "region", "pop_total","pop_with_data", "pop_sim", "wgt_adjpro", "growth_type", "preference" )
        df_plot <- df %>%
          select_at(vars(var_list)) %>%
          mutate(learning_poverty=100-wgt_adjpro) %>%
          select(-wgt_adjpro) %>%
          tidyr::spread(key=growth_type, value=learning_poverty)
        
        
        
      }
      
      else if (input$groupingsim=="initial_poverty_level") {
        var_list<-c("year", "initial_poverty_level", "pop_total","pop_with_data", "pop_sim", "wgt_adjpro", "growth_type", "preference" )
        df_plot <- df %>%
          select_at(vars(var_list)) %>%
          mutate(learning_poverty=100-wgt_adjpro) %>%
          mutate(region=initial_poverty_level) %>%
          select(-wgt_adjpro) %>%
          tidyr::spread(key=growth_type, value=learning_poverty)        
        
        
      }
      else if (input$groupingsim=="incomelevel") {
        var_list<-c("year", "incomelevel", "pop_total","pop_with_data", "pop_sim", "wgt_adjpro", "growth_type", "preference" )
        df_plot <- df %>%
          select_at(vars(var_list)) %>%
          mutate(learning_poverty=100-wgt_adjpro) %>%
          mutate(region=incomelevel) %>%
          select(-wgt_adjpro) %>%
          tidyr::spread(key=growth_type, value=learning_poverty)        
        
        
      }     
      df_plot_regional<- df_plot %>%
        filter(region!="Global")     
      
      names<-colnames(df_plot_regional[,grep("r5|r6|r7|r8|r9",colnames(df_plot_regional))])
      
      df_plot_regional_wide<- df_plot_regional %>% 
        select(-c( 'pop_total', 'pop_with_data', 'pop_sim', 'preference')) %>%
        gather('own', names, key='type', value='pov') %>%
        spread(year, pov )
      
      write.csv(df_plot_regional_wide, file=paste(input$directory,"figure4b_data.csv", sep=""))
      
      p2<-ggplot(df_plot_regional, aes(x=year, colour=region)) +
        geom_line(aes(y=r50)) +
        geom_point(aes(y=r50)) +
        geom_line(aes(y=r80), linetype="dashed") +
        geom_point(aes(y=r80)) +  
        labs(y="Learning Poverty", title="Simulation of Regional Learning Poverty") +
        theme_classic() 
      
      excl<-read_xlsx()
      excl<-xl_add_vg(excl, sheet="Feuil1", code = print(p2), 
                      width = 6, height = 6, left = 1, top = 2 )
      print(excl, target=paste(input$directory,"figure4b.xlsx", sep=""))
      
    })
    #####################################
    #create table for spell growth rates
    #####################################
    
    
    if (input$groupingsim=="region") {    
      ##Spell Growth Table##
      tab_spells <- df %>%
        filter(year==2015 & region!="Global") %>%
        select(region, wgt_growth_rate, growth_type) %>%
        spread(growth_type, wgt_growth_rate ) 
      
      #output results to window
      output$sim_spells <- DT::renderDataTable({
        DT::datatable(tab_spells, caption="Table 1. Spell Growth Rates by Group",
                      colnames=c('Region'='region', 
                                 'Business as Usual'='own',
                                 'Regional 50th Percentile'='r50',
                                 'Regional 60th Percentile'='r60',
                                 'Regional 70th Percentile'='r70',
                                 'Regional 80th Percentile'='r80',
                                 'Regional 90th Percentile'='r90'),
                      extensions = 'Buttons', options=list(
                        dom = 'Bfrtip',
                        buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
                      ))
        
      })
    }
    else if (input$groupingsim=="initial_poverty_level") {    
      ##Spell Growth Table##
      tab_spells <- df %>%
        filter(year==2015 & initial_poverty_level!="Global") %>%
        select(initial_poverty_level, wgt_growth_rate, growth_type) %>%
        spread(growth_type, wgt_growth_rate )
      
      #output results to window
      output$sim_spells <- DT::renderDataTable({
        DT::datatable(tab_spells, caption="Table 1. Spell Growth Rates by Group",
                      colnames=c('Learning Povety Level'='initial_poverty_level', 
                                 'Business as Usual'='own',
                                 'Group 50th Percentile'='r50',
                                 'Group 60th Percentile'='r60',
                                 'Group 70th Percentile'='r70',
                                 'Group 80th Percentile'='r80',
                                 'Group 90th Percentile'='r90'),
                      extensions = 'Buttons', options=list(
                        dom = 'Bfrtip',
                        buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
                      ))
        
      })
    }
    else if (input$groupingsim=="incomelevel") {    
      ##Spell Growth Table##
      tab_spells <- df %>%
        filter(year==2015 & incomelevel!="Global") %>%
        select(incomelevel, wgt_growth_rate, growth_type) %>%
        spread(growth_type, wgt_growth_rate )
      
      #output results to window
      output$sim_spells <- DT::renderDataTable({
        DT::datatable(tab_spells, caption="Table 1. Spell Growth Rates by Group",
                      colnames=c('Income Level'='incomelevel', 
                                 'Business as Usual'='own',
                                 'Group 50th Percentile'='own',
                                 'Group 60th Percentile'='r60',
                                 'Group 70th Percentile'='r70',
                                 'Group 80th Percentile'='r80',
                                 'Group 90th Percentile'='r90'),
                      extensions = 'Buttons', options=list(
                        dom = 'Bfrtip',
                        buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
                      ))
        
      })
    }
    ##############################
    #create table for sim numbers
    ##############################
    tab_path<-paste("C:/Users/",Sys.getenv("USERNAME"),"/Documents/Github/LearningPoverty/02_simulation/023_outputs/",input$filename ,"_sim_table.dta", sep="")
    tab1<-haven::read_dta(tab_path)    

    if (input$groupingsim=="region") {    
      tab <- reactive({
        tab1 %>%
        select(region, pop_sim_2015, pop_sim_2030, learning_poverty2015r50, learning_poverty2030r50, paste('learning_poverty2030', input$high_scenario, sep=''), country_count_2015)
      })
      
      #output results to window
      output$sim_output <- DT::renderDataTable({
        DT::datatable(tab(), caption="Table 2. Learning Poverty Simulations by Group",
                      colnames=c('Region'='region', 'Population - 2015'='pop_sim_2015', 'Population - 2030'='pop_sim_2030', 
                                 'Learning Poverty - 2015'= 'learning_poverty2015r50',
                                 'Learning Poverty - 2030- Business as Usual'= 'learning_poverty2030r50',
                                 'Learning Poverty - 2030- High Scenario'= paste('learning_poverty2030', input$high_scenario, sep=''), 
                                 '# of Countries with Data' = 'country_count_2015'),
                      extensions = 'Buttons', options=list(
                        dom = 'Bfrtip',
                        buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
                      ))
        
      })
    }
    else if (input$groupingsim=="initial_poverty_level") {    
      
      tab <- reactive({
        tab1 %>%
          select(initial_poverty_level, pop_sim_2015, pop_sim_2030, learning_poverty2015r50, learning_poverty2030r50, paste('learning_poverty2030', input$high_scenario, sep=''), country_count_2015)
      })

      #output results to window
      output$sim_output <- DT::renderDataTable({
        DT::datatable(tab(), caption="Table 2. Learning Poverty Simulations by Group",
                      colnames=c('Initial Poverty Level'='initial_poverty_level', 'Population - 2015'='pop_sim_2015', 'Population - 2030'='pop_sim_2030', 
                                 'Learning Poverty - 2015'= 'learning_poverty2015r50',
                                 'Learning Poverty - 2030- Business as Usual'= 'learning_poverty2030r50',
                                 'Learning Poverty - 2030- High Scenario'= paste('learning_poverty2030', input$high_scenario, sep=''), 
                                 '# of Countries with Data' = 'country_count_2015'),
                      extensions = 'Buttons', options=list(
                        dom = 'Bfrtip',
                        buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
                      ))
        
      })
    }
    else if (input$groupingsim=="incomelevel") {    
      tab <- reactive({
        tab1 %>%
          select(incomelevel, pop_sim_2015, pop_sim_2030, learning_poverty2015r50, learning_poverty2030r50, paste('learning_poverty2030', input$high_scenario, sep=''), country_count_2015)
      })
      #output results to window
      output$sim_output <- DT::renderDataTable({
        DT::datatable(tab(), caption="Table 2. Learning Poverty Simulations by Group",
                      colnames=c('Income Level'='incomelevel', 'Population - 2015'='pop_sim_2015', 'Population - 2030'='pop_sim_2030', 
                                 'Learning Poverty - 2015'= 'learning_poverty2015r50',
                                 'Learning Poverty - 2030- Business as Usual'= 'learning_poverty2030r50',
                                 'Learning Poverty - 2030- High Scenario'= paste('learning_poverty2030', input$high_scenario, sep=''), 
                                 '# of Countries with Data' = 'country_count_2015'),
                      extensions = 'Buttons', options=list(
                        dom = 'Bfrtip',
                        buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
                      ))
        
      })
    }
    
    ########################################
    #create table for sim numbers by country
    ########################################
    tab_country_path<-paste("C:/Users/",Sys.getenv("USERNAME"),"/Documents/Github/LearningPoverty/02_simulation/023_outputs/",input$filename ,"_country_sim_table.dta", sep="")
    tab_country1<-haven::read_dta(tab_country_path)    

    tab_country <- reactive({
      tab_country1 %>%
        mutate(change_bau=(learning_poverty2030r50*pop_2030/100)/1000000-(learning_poverty2015r50*pop_2015/100)/1000000) %>%
        mutate(change_high=(get(paste('learning_poverty2030', input$high_scenario, sep=''))*pop_2030/100)/1000000-(learning_poverty2015r50*pop_2015/100)/1000000) %>%
        mutate(pop_learning_assessment_2015=pop_2015*country_count_2015) %>%
        mutate(pop_learning_assessment_2030=pop_2030*country_count_2015) %>%
        select(countrycode, regionname, incomelevelname, lendingtypename, countryname, change_bau, change_high, pop_2015, pop_2030, pop_2021, pop_2023,
             learning_poverty2015r50, learning_poverty2030r50, paste('learning_poverty2030', input$high_scenario, sep=''), 
             country_count_2015, pop_learning_assessment_2015, pop_learning_assessment_2030)        %>%
        arrange(change_high)
    })
    
    #output results to window
    output$sim_output_country <- DT::renderDataTable(server=FALSE, {
      DT::datatable(tab_country(),  caption="Table 3. Learning Poverty Simulations by Country",
                    colnames=c('Country Code'='countrycode', 'Region'='regionname', 'Income Level'='incomelevelname', 'Lending Type' = 'lendingtypename', 'Country'='countryname', 
                               'Change between 2015 and 2030 (in millions) - Business as usual'='change_bau',	
                               'Change between 2015 and 2030 (in millions) - High Scenario'='change_high',
                               'Population - 2015'='pop_2015', 'Population - 2030'='pop_2030', 
                               'Learning Poverty - 2015'= 'learning_poverty2015r50',
                               'Learning Poverty - 2030- Business as Usual'= 'learning_poverty2030r50',
                               'Learning Poverty - 2030- High Scenario'= paste('learning_poverty2030', input$high_scenario, sep=''), 
                               'Population with Learning Assessment - 2015'='pop_learning_assessment_2015', 
                               'Population  with Learning Assessment - 2030'='pop_learning_assessment_2030', 
                               'Country has Data' = 'country_count_2015'),
                    extensions = c('Buttons'), options=list(
                      dom = 'Bfrtip',
                      buttons = c('copy', 'csv', 'excel', 'pdf', 'print'))
                    
      )
      
    })
    
    
    
    output$sim_input <- renderText ( {
      prog
      
    })
    
    save(df, tab1, tab_country1, file=paste("C:/Users/",Sys.getenv("USERNAME"),"/Documents/Github/LearningPoverty/02_simulation/023_outputs/",input$filename ,"_sim_numbers.RData", sep=""))
    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
