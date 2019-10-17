

#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(plotly)
library(DT)

wrapper <- function(x, ...) 
{
  paste(strwrap(x, ...), collapse = "\n")
}


# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Learning Poverty Simulation Tool"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      h2("The Simulation"),
      p("This tool shows how much progress can be made reducing Learning Poverty over time under a business as usual and a high growth scenario."),  
      p("In the figures and tables below, we show reductions in learing poverty at the global, regional, and country level.  
        Modify the growth rates to see how differences in rates of progress affect how fast Learning Poverty is eliminated."),
      h2("Start Simulation"),
      actionButton("gobutton", "Start Simulation"),
      h3("Make Changes to Simulation"),
      p("In order to simulate how fast countries can eliminate Learning Poverty, we show a High Scenario, where countries grow at the upper percentiles for their region.  By default, we consider growth at the regional 80th percentile."),  
      p("Make changes to see how quickly Learning Poverty will be reduced under different growth assumptions."),
      selectInput('high_scenario', "Specify regional percentile for high growth scenario", choices=c("r60","r70","r80","r90"), selected="r80"),
      selectInput('ci', "Show Confidence Intervals", choices=c("No", "Yes"), selected="No"),
      includeMarkdown('lpov_desc.md'),      
      h3("How Fast are Regions Reducing Learning Poverty?"),
      includeMarkdown('special_simulation_spells_nopasec_weigthed_pref1005.md')      
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      
      downloadButton("downloaddata1", "Download global plot data to csv file"),
      plotlyOutput("sim_figures1"),
      downloadButton("downloaddata2", "Download regional plot data to csv file"),
      plotlyOutput("sim_figures2"),
      DT::dataTableOutput("sim_output"),
      DT::dataTableOutput("sim_output_country")
      
      
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  observeEvent(input$gobutton, {


    
    #load data from sim
    load('simulation_dataframe_public_sim_numbers_lower_ci.RData')
    df_lower<-df
    
    load('simulation_dataframe_public_sim_numbers_upper_ci.RData')
    df_upper<-df
    
    load('simulation_dataframe_public_sim_numbers.RData')
    
    ######################################
    #Create ggplot of simulation over time
    ######################################
    output$sim_figures1 <- renderPlotly({

        
        var_list<-c("year", "region", "pop_total","pop_with_data", "pop_sim", "wgt_adjpro", "growth_type", "preference" )
        df_plot <- df %>%
          select_at(vars(var_list)) %>%
          mutate(learning_poverty=100-wgt_adjpro) %>%
          select(-wgt_adjpro) %>%
          tidyr::spread(key=growth_type, value=learning_poverty)
        
        df_plot_global<- df_plot %>%
          filter(region=="Global")
        
        #Lower 95% CI
        df_plot_lower <- df_lower %>%
          select_at(vars(var_list)) %>%
          mutate(learning_poverty=100-wgt_adjpro) %>%
          select(-wgt_adjpro) %>%
          tidyr::spread(key=growth_type, value=learning_poverty)
        
        df_plot_global_lower<- df_plot_lower %>%
          filter(region=="Global")
        
        #Upper 95% CI
        df_plot_upper <- df_upper %>%
          select_at(vars(var_list)) %>%
          mutate(learning_poverty=100-wgt_adjpro) %>%
          select(-wgt_adjpro) %>%
          tidyr::spread(key=growth_type, value=learning_poverty)
        
        df_plot_global_upper<- df_plot_upper %>%
          filter(region=="Global")
        
      rgrp<-reactive({
        df_plot_global %>%
          select(input$high_scenario) %>%
          mutate(val=get(input$high_scenario))
      })
      
      rgrp_lower<-reactive({
        df_plot_global_lower %>%
          select(input$high_scenario) %>%
          mutate(val=get(input$high_scenario))
      })
      
      rgrp_upper<-reactive({
        df_plot_global_upper %>%
          select(input$high_scenario) %>%
          mutate(val=get(input$high_scenario))
      })
      
      if (input$ci=="Yes") {
      df_plot_global %>%
        plot_ly(x= ~df_plot_global$year, y=~df_plot_global$r50, type="scatter", mode='lines+markers', name="Business as Usual"  ) %>%
        add_trace(x= ~df_plot_global$year, y=~rgrp()$val, line = list(widthh=0.5, dash="dot"), name=paste("High Scenario", input$high_scenario, sep=" ")  ) %>%
        add_ribbons(x = df_plot_global$year, ymin = df_plot_global_lower$r50, ymax = df_plot_global_upper$r50,
                    color = I("gray95"), name = "95% confidence") %>%
        add_ribbons(x = df_plot_global$year, ymin = ~rgrp_lower()$val, ymax = ~rgrp_upper()$val,
                    color = I("gray95"), name = "95% confidence") %>%
        layout(xaxis=list(title="Simulation of Global Learning Poverty"), yaxis=list(title="Learning Poverty")) %>%
        layout(hovermode = 'compare')  %>%
        layout(
          yaxis = list(rangemode = "tozero"))
      } else if (input$ci=="No") {
      df_plot_global %>%
        plot_ly(x= ~df_plot_global$year, y=~df_plot_global$r50, type="scatter", mode='lines+markers', name="Business as Usual"  ) %>%
        add_trace(x= ~df_plot_global$year, y=~rgrp()$val, line = list(widthh=0.5, dash="dot"), name=paste("High Scenario", input$high_scenario, sep=" ")  ) %>%
        layout(xaxis=list(title="Simulation of Global Learning Poverty"), yaxis=list(title="Learning Poverty")) %>%
        layout(hovermode = 'compare')  %>%
        layout(
          yaxis = list(rangemode = "tozero"))
      }
      
      
      
    })  
    
    df_plot_glob<-reactive({
      

        
        var_list<-c("year", "region", "pop_total","pop_with_data", "pop_sim", "wgt_adjpro", "growth_type", "preference" )
        df_plot <- df %>%
          select_at(vars(var_list)) %>%
          mutate(learning_poverty=100-wgt_adjpro) %>%
          select(-wgt_adjpro) %>%
          tidyr::spread(key=growth_type, value=learning_poverty)
        
      
      

      
      df_plot_global<- df_plot %>%
        filter(region=="Global")
      
      names<-colnames(df_plot_global[,grep("r5|r6|r7|r8|r9",colnames(df_plot_global))])
      


        df_plot_global_wide<- df_plot_global %>% 
          select(-c( 'pop_total', 'pop_with_data', 'pop_sim', 'preference')) %>%
          gather('own', names, key='type', value='pov') %>%
          spread(year, pov )
        
        df_plot_global_wide
    })
    

      
  
    
    # Downloadable png of selected dataset ----
    output$downloaddata1 <- downloadHandler(
      filename = function() {
        paste("global_data-", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        write.csv(df_plot_glob(), file)
        }
    )
    
    

    
    ###############################################
    #Create ggplot of simulation over time by group
    ###############################################
    output$sim_figures2 <- renderPlotly({

        
        var_list<-c("year", "region", "pop_total","pop_with_data", "pop_sim", "wgt_adjpro", "growth_type", "preference" )
        df_plot <- df %>%
          select_at(vars(var_list)) %>%
          mutate(learning_poverty=100-wgt_adjpro) %>%
          select(-wgt_adjpro) %>%
          tidyr::spread(key=growth_type, value=learning_poverty)
        
      df_plot_regional<- df_plot %>%
        filter(region!="Global") %>%
        mutate(region=case_when(
          region=="EAS" ~ "EAP",
          region=="ECS" ~ "ECA",
          region=="LCN" ~ "LAC",
          region=="MEA" ~ "MENA",
          region=="SAS" ~ "SAR",
          region=="SSF" ~ "SSA"
                  ))
  
      
      #Lower 95% CI
      df_plot_lower <- df_lower %>%
        select_at(vars(var_list)) %>%
        mutate(learning_poverty=100-wgt_adjpro) %>%
        select(-wgt_adjpro) %>%
        tidyr::spread(key=growth_type, value=learning_poverty)
      
      df_plot_regional_lower<- df_plot_lower %>%
        filter(region!="Global") %>%
        mutate(region=case_when(
          region=="EAS" ~ "EAP",
          region=="ECS" ~ "ECA",
          region=="LCN" ~ "LAC",
          region=="MEA" ~ "MENA",
          region=="SAS" ~ "SAR",
          region=="SSF" ~ "SSA"
        ))
      
      #Upper 95% CI
      df_plot_upper <- df_upper %>%
        select_at(vars(var_list)) %>%
        mutate(learning_poverty=100-wgt_adjpro) %>%
        select(-wgt_adjpro) %>%
        tidyr::spread(key=growth_type, value=learning_poverty)
      
      df_plot_regional_upper<- df_plot_upper %>%
        filter(region!="Global") %>%
        mutate(region=case_when(
          region=="EAS" ~ "EAP",
          region=="ECS" ~ "ECA",
          region=="LCN" ~ "LAC",
          region=="MEA" ~ "MENA",
          region=="SAS" ~ "SAR",
          region=="SSF" ~ "SSA"
        ))      
      
      rgrp_reg<-reactive({
        df_plot_regional %>%
          select(input$high_scenario) %>%
          mutate(val=get(input$high_scenario))
      })

      rgrp_reg_lower<-reactive({
        df_plot_regional_lower %>%
          select(input$high_scenario) %>%
          mutate(val=get(input$high_scenario))
      })
      
      rgrp_reg_upper<-reactive({
        df_plot_regional_upper %>%
          select(input$high_scenario) %>%
          mutate(val=get(input$high_scenario))
      })
      if (input$ci=="No") {
      df_plot_regional %>%
        plot_ly(x= ~df_plot_regional$year, y=~df_plot_regional$r50, type="scatter", mode='lines+markers',  color=~df_plot_regional$region  ) %>%
        add_trace(x= ~df_plot_regional$year, y=~rgrp_reg()$val, line = list(widthh=0.5, dash="dot", color=~df_plot_regional$region)     ) %>%
        layout(xaxis=list(title="Simulation of Regional Learning Poverty"), yaxis=list(title="Learning Poverty")) %>%
        layout(hovermode = 'compare')  %>%
        layout(
          yaxis = list(rangemode = "tozero"))
      } else if (input$ci=="Yes") {
        df_plot_regional %>%
          plot_ly(x= ~df_plot_regional$year, y=~df_plot_regional$r50, type="scatter", mode='lines+markers',  color=~df_plot_regional$region  ) %>%
          add_trace(x= ~df_plot_regional$year, y=~rgrp_reg()$val, line = list(widthh=0.5, dash="dot", color=~df_plot_regional$region)     ) %>%
          add_ribbons(x = df_plot_regional$year, ymin = df_plot_regional_lower$r50, ymax = df_plot_regional_upper$r50,
                      name = "95% confidence", color=~df_plot_regional$region) %>%
          add_ribbons(x = df_plot_regional$year, ymin = ~rgrp_reg_lower()$val, ymax = ~rgrp_reg_upper()$val,
                      name = "95% confidence", color=~df_plot_regional$region) %>%
          layout(xaxis=list(title="Simulation of Regional Learning Poverty"), yaxis=list(title="Learning Poverty")) %>%
          layout(hovermode = 'compare')  %>%
          layout(
            yaxis = list(rangemode = "tozero"))
      }
      
    })
    
    df_plot_reg<-reactive({
      

      
      

        
        var_list<-c("year", "region", "pop_total","pop_with_data", "pop_sim", "wgt_adjpro", "growth_type", "preference" )
        df_plot <- df %>%
          select_at(vars(var_list)) %>%
          mutate(learning_poverty=100-wgt_adjpro) %>%
          select(-wgt_adjpro) %>%
          tidyr::spread(key=growth_type, value=learning_poverty)
        
        
        
      
 
      df_plot_regional<- df_plot %>%
        filter(region!="Global")     
      
      names<-colnames(df_plot_regional[,grep("r5|r6|r7|r8|r9",colnames(df_plot_regional))])
      
      df_plot_regional_wide<- df_plot_regional %>% 
        select(-c( 'pop_total', 'pop_with_data', 'pop_sim', 'preference')) %>%
        gather('own', names, key='type', value='pov') %>%
        spread(year, pov )
      
      df_plot_regional_wide

    })
    
    # Downloadable png of selected dataset ----
    output$downloaddata2 <- downloadHandler(
      filename = function() {
        paste("regional_data-", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        write.csv(df_plot_reg(), file)
      }
    )

    ##############################
    #create table for sim numbers
    ##############################

    
 
      tab <- reactive({
        tab1 %>%
        select(region, pop_sim_2015, pop_sim_2030, learning_poverty2015r50, learning_poverty2030r50, paste('learning_poverty2030', input$high_scenario, sep=''), country_count_2015)    %>%
          filter(region!="NAC") %>%
          mutate(region=case_when(
            region=="EAS" ~ "EAP",
            region=="ECS" ~ "ECA",
            region=="LCN" ~ "LAC",
            region=="MEA" ~ "MENA",
            region=="SAS" ~ "SAR",
            region=="SSF" ~ "SSA",
            TRUE ~ region
          ))
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
                      )) %>%
          DT::formatRound(columns=c('Learning Poverty - 2015','Learning Poverty - 2030- Business as Usual','Learning Poverty - 2030- High Scenario' ), 2)
        
      })
    
    
    ########################################
    #create table for sim numbers by country
    ########################################
  
    

    
    tab_country <- reactive({
      tab_country1 %>%
        mutate(change_bau=(learning_poverty2030r50*pop_2030/100)/1000000-(learning_poverty2015r50*pop_2015/100)/1000000) %>%
        mutate(change_high=(get(paste('learning_poverty2030', input$high_scenario, sep=''))*pop_2030/100)/1000000-(learning_poverty2015r50*pop_2015/100)/1000000) %>%
        mutate(pop_learning_assessment_2015=pop_2015*country_count_2015) %>%
        mutate(pop_learning_assessment_2030=pop_2030*country_count_2015) %>%
        select(countrycode, regionname, incomelevelname, lendingtypename, countryname, change_bau, change_high, pop_2015, pop_2030,
             learning_poverty2015r50, learning_poverty2030r50, paste('learning_poverty2030', input$high_scenario, sep=''))        %>%
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
                               'Learning Poverty - 2030- High Scenario'= paste('learning_poverty2030', input$high_scenario, sep='')),
                    extensions = c('Buttons'), options=list(
                      dom = 'Bfrtip',
                      buttons = c('copy', 'csv', 'excel', 'pdf', 'print'))
                    
      ) %>%
        DT::formatRound(columns=c('Change between 2015 and 2030 (in millions) - Business as usual',
                                  'Change between 2015 and 2030 (in millions) - High Scenario',
                                  'Learning Poverty - 2015','Learning Poverty - 2030- Business as Usual','Learning Poverty - 2030- High Scenario' ), 2)
      
      
    })
    
    

  })
}

# Run the application 
shinyApp(ui = ui, server = server)
