## app.R ##
library(shinydashboard)
library(wbstats)
library(magrittr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)


# Choose subset of indicator codes:
indicator.codes = c("Gross Domestic Products"= "NY.GDP.MKTP.CD",
                    "GDP Growth Rate"= "SP.POP.DPND.OL",
                    "GDP per Capita" = "NY.GDP.PCAP.CD",
                    "Export of goods" = "NE.EXP.GNFS.CD",
                    "Import of goods" = "NE.IMP.GNFS.CD",
                    "Labor force participation" = "NY.GDS.TOTL.ZS",
                    "Life expectancy"= "SP.DYN.LE00.IN",
                    "Population 65 and Above Proportion"= "SP.POP.65UP.TO.ZS",
                    "Birth Rate"= "SP.DYN.CBRT.IN",
                    "Population Growth" = "SP.POP.GROW",
                    "Age Dependency Ratio" = "SH.XPD.PUBL.GX.ZS",
                    "Health Expenditure"= "SL.TLF.CACT.NE.ZS",
                    "Gross Domestic Savings" = "NY.GDP.MKTP.KD.ZG",
                    "Total Population" = "SP.POP.TOTL",
                    "Surface areas" = "AG.SRF.TOTL.K2"
                    )

bubble.codes = c("Gross Domestic Products"= "NY.GDP.MKTP.CD", "Total Population" = "SP.POP.TOTL",
                 "Surface areas" = "AG.SRF.TOTL.K2")


lookup=data.frame(indicator_name=c("NY.GDP.MKTP.CD","SP.DYN.LE00.IN","SP.POP.65UP.TO.ZS","SP.DYN.CBRT.IN",
                         "SP.POP.DPND.OL", "SH.XPD.PUBL.GX.ZS", "SL.TLF.CACT.NE.ZS", "NY.GDS.TOTL.ZS",
                         "NE.EXP.GNFS.CD","NE.IMP.GNFS.CD", "SP.POP.TOTL", "SP.POP.GROW",
                         "NY.GDP.MKTP.KD.ZG", "AG.SRF.TOTL.K2","NY.GDP.PCAP.CD"),
                  name=c("GDP Values (US Dollars)", "Life Expectancy", "Population 65+ (% of total population)", "Birth Rate (per 1000 people)",
                         "GDP Growth Rate (annual %)", "Age Dependency Ratio (%)", "Health Expenditure (%)", "Labor force participation rate (%)",
                          "Export of goods ($)","Import of goods ($)", 
                  "Total Population" ,"Population Growth (%)",
                  "Gross Domestic Savings (% of GDP)" ,"Surface areas (sq. kilometers)","GDP per Capita ($)")
)

# Retrieve a "long" table with data for 
# the chosen countries and indicator codes 
# over the chosen date range 
wb.long.df = wb(indicator = indicator.codes, # a vector of indicator codes
                country   = "all",           # a vector of country codes
                startdate = 2000,            # see documentation for format
                enddate   = 2016,            # of months and quarters
                freq      = "Y",             # options: "Y", "Q", "M"
                POSIXct   = TRUE             # return dates as POSIXct type
)

# Use the spread function to create
# indicator code variables/columns
# Create indicator variables from the `indicatorID` and `value` variables
wb.long.df %>%
  spread(., indicatorID, value) %>%
  select(., -indicator) %>%
  {.} -> wb.df


# Join the data in the `wb_cachelist$countries` dataset
# to the data in the `wb.df` dataset 
wb.df %>%
  left_join(x=., 
            y=wb_cachelist$countries) %>%
            {.} -> wb.df
#wb.df %>%
 # left_join(x=.,
  #          y=lookup, by="indicator") %>%
   #         {.} -> wb.df
  

# Store the sorted list of iso3c country codes
iso3c.codes = sort(unique(wb.df$iso3c))
country.codes=sort(unique(wb.df$country))


# Create the UI element
ui <- 
  dashboardPage(
    skin="green",
    #title="World Development",
    header=dashboardHeader(title="WDI"),
    ## Sidebar content
    sidebar=dashboardSidebar(
      sidebarMenu(
        menuItem("Home",        tabName="home_tab",   icon=icon(name="home",       lib="glyphicon")),
        menuItem("Summary Statistics", tabName="first_tab",  icon=icon(name="menu-right", lib="glyphicon")),
        #menuItem("Histogram", tabName="second_tab", icon=icon(name="menu-right", lib="glyphicon")),
        menuItem("Line Graph", tabName="third_tab", icon=icon(name="menu-right", lib="glyphicon")),
        menuItem("Scatter Plot", tabName="fourth_tab", icon=icon(name="menu-right", lib="glyphicon")),
        menuItem("World Map", tabName="fifth_tab", icon=icon(name="menu-right", lib="glyphicon")),
        menuItem("Conclusion", tabName="sixth_tab", icon=icon(name="menu-right", lib="glyphicon"))
        #menuItem("Heat Map", tabName="sixth_tab", icon=icon(name="menu-right", lib="glyphicon"))
      )
    ),
    ## Body content
    body=dashboardBody(
      tabItems(
        # Tab content for "home_tab"
        tabItem(tabName="home_tab",
                h2("World Development Interactive Dashboard"),
                h5("Nam Pham - Bentley University"),
                fluidRow(
                  box(width=4, background="blue", title=p(strong("Introduction")),"This project
                      aims to demonstrate the use of different charts and graphs
                      in examining the World Bank indicators. Users can interact by exploring the tabs on the left and 
                      choosing countries/indicators of their interests."),
                  box(width=4, background="blue", title=p(strong("Topic"))   ,"To demonstrate the use of these graphs, we observe the effects of aging population on GDP growth in the world. We choose Japan and 
                      compare its age structure and economics variables to other countries over the last 15 years."),
                  #box(width=4, background="blue", title=p(strong("Objective"))  ,"Our overall goal is to provide 
                #an interactive method to explore basic statistics about any country and examine
                  #    its socio-economic development over time relative to other countries."),
                box(width=4, background="blue", title=p(strong("Dataset"))  ,"Our dataset is obtained from World Bank Group, using the wbstats library in R. This dataset contains socio-economics variables of all countries in the
                    world in the past 50 years. Data was cleansed, formatted, and subset from 2000 to 2015."),
                  box(width=12, title=p(strong("About the Project")),
                      p("This project is developed using RStudio Shiny Dashboard. The following libraries are used:"),
                      p("library(shinydashboard)"),
                      p("library(wbstats)"),
                      p("library(magrittr)"),
                      p("library(dplyr)"),
                      p("library(tidyr)"),
                      p("library(ggplot2)"),
                      p("library(plotly)")
                      
                  )
                  
                )
                
                
                       
                
        ),
        
        # Tab content for "first_tab"
        tabItem(tabName="first_tab",
                fluidRow(
                  box(width=12, background="blue", title=p(strong("Summary Statistics")),"Choose an indicator 
                      and list of countries - the summary table and bar chart quickly compare the 
                      average value of the chosen indicator among these countries. Japan has relatively higher GDP 
                      and GDP per capita than South Korea, a similar country in the region. The level is similar to Germany but 
                      falls behind the US. However, GDP Growth Rate of Japan is the highest among these countries."),
                  box(width=12, selectInput("summary_indicator", "Choose an indicator: ", 
                                            multiple=FALSE, 
                                            selected="NY.GDP.MKTP.CD",
                                            choices=indicator.codes)),
                  box(width=12, selectInput("first_iso3c", "Choose one or more countries: ", 
                                            multiple=TRUE, 
                                            selected=c("Japan","Korea, Rep.","Germany", "United States"),
                                            choices=country.codes)),
                  box(width=12, tableOutput("avg_by_iso3c")),
                  box(width=12, plotlyOutput("bar_chart"))
                )
        ),
        
        # tab content for "second_tab" 
        tabItem(tabName="second_tab",
                fluidRow(
                  box(width=12, background="blue", title="Histogram",
                      "Histogram shows us the frequency of a variable"),
                  box(width=12, selectInput("first_iso3c_2", "Choose one or more countries: ", 
                                            multiple=TRUE, 
                                            selected="FRA",
                                            choices=country.codes)), 
                  box(width=12, selectInput("indicator_2", "Select an indicator:", multiple=TRUE,
                                            selected="NY.GDP.MKTP.CD",
                                            choices=indicator.codes)),
                  
                  # To do: create another box to select a indicator code from 
                  # the `indicator.codes` vector. You will use this selected value 
                  # below to create `output$ic_histogram`
                  
                  box(width=12,sliderInput("bins",
                                  "Number of bins:",
                                  min = 1,
                                  max = 50,
                                  value = 30)
                    ),
                    
                  
                  box(width=12, plotlyOutput("ic_histogram"))
                  #box(width=12, plotlyOutput("scatter_plot"))
                )
        ),
        # tab content for "third_tab'
        tabItem(tabName="third_tab",
                fluidRow(
                  box(width=12, background="blue", title=p(strong("Line Graph")),
                      "Choose countries and one indicator from the list. Line graph
                      shows the change of the indicator value in each country over the period 2000 to 2015. 
                      For example, in the default graph, we can see that the population 65+ in 
                      Japan is increasing rapidly compared to UK and Germany. On the other hand, health expenditure in Japan has 
                      picked up since 2012, which put heavy pressure on the economy."),
                  box(width=4, selectInput("first_iso3c_3_1", "Choose first country: ", 
                                            selected=c("Japan"), 
                                            choices=country.codes)), 
                  box(width=4, selectInput("first_iso3c_3_2", "Choose another country: ", 
                                            selected=c("United States"), 
                                            choices=country.codes)), 
                  box(width=4, selectInput("first_iso3c_3_3", "Choose another country: ", 
                                            selected=c("Germany"), 
                                            choices=country.codes)), 
                  box(width=12, selectInput("indicator_3", "Select an indicator:",
                                            selected="SP.POP.65UP.TO.ZS",
                                            choices=indicator.codes)),
                  box(width=12, plotlyOutput("line_plot"))
                  )
        ),
        # tab content for "fourth_tab" 
        tabItem(tabName="fourth_tab",
                fluidRow(
                  box(width=12, background="blue", title=p(strong("Scatter Plot")),
                      "Choose two indicators: the plot will graph the
                      average values for two indicators for all countries in the world. Based on
                      this information, we can observe the linear dependency between two 
                      selected variables. Hover your pointer to see where 
                      each country is placed and click on region to hide/unhide. In this example, there might be a negative correlation
                      between older population proportion and birth rate. We can also find that lower birth rate correlates to higher GDP Growth."),
                  box(width=4, selectInput("indicator_4_1", "Select first indicator: ", 
                                            selected="SP.DYN.CBRT.IN",
                                            choices=indicator.codes)), 
                  box(width=4, selectInput("indicator_4_2", "Select second indicator: ",  
                                            selected="SP.POP.65UP.TO.ZS",
                                            choices=indicator.codes)),
                  box(width=4, selectInput("indicator_4_3", "Select indicator for bubble size: ",  
                                           selected="SP.POP.DPND.OL",
                                           choices=bubble.codes)),
                  box(width=12, plotlyOutput("scatter_plot"))
                )
        ),
        tabItem(tabName="fifth_tab",
                fluidRow(
                  box(width=12, background="blue", title=p(strong("World Map")),"The world map (choropleth)
                      displays the average value of your chosen variable for every 
                      country and plot on the world map. In this case, we can 
                      see that Japan has relatively life expectancy (80 years old) compared 
                      to other countries in the world. It also has one of the highest old people population and lowest birth rate in the world."),
                  box(width=12, selectInput("indicator_5", "Choose an indicator to display on the map: ", 
                                            selected=c("SP.POP.65UP.TO.ZS"),
                                            choices=indicator.codes)),
                  box(width=12, plotlyOutput("world_map"))
                )
        ),
        
        tabItem(tabName="sixth_tab",
                fluidRow(
                 box(width=12, title="Conclusion",
                     p("Based on the visualization tools, we generate the following insights:"),
                     p("- Japan remains one of the strongest economy in the world, with extremely high GDP and GDP per capita despite its limited resources"),
                     p("- However, in recent years, its aging structure has become troublesome as the proportion of old people has increased significantly while birth rates keep declining"),
                     p("- This has put pressure on the economy has younger people has to take care of more old people in the country. Age dependency ratio continues to increase while health expenditure rises placed responsibility 
                       of supporting the economy on younger people. This in turn discourages younger people to start families and have children, which turns into a viscious circle.")
                     ) 
                 )
        )
    )
  )
  )

server <- function(input, output) {
  
  output$avg_by_iso3c <- renderTable({ 
    wb.df %>%
      filter(country %in% input$first_iso3c) %>% 
      group_by(country) %>%
      mutate_(chosen_sc=input$summary_indicator) %>%
      summarize(Average_Value=mean(chosen_sc,na.rm=TRUE)) %>%
      arrange(desc(Average_Value)) %>%
      mutate_each(funs(prettyNum(.,big.mark=",", scientific=FALSE))) 
      # Sort the output to make it easier to read
      # Format the output  commas
  })
  
  output$bar_chart <- renderPlotly({
    wb.df%>%
      filter(country %in% input$first_iso3c) %>%
      group_by(country) %>%
      mutate_(chosen_sc=input$summary_indicator) %>%
      summarize(avg=mean(chosen_sc, na.rm=TRUE))%>%
      arrange(desc(avg)) %>%
      mutate_each(funs(prettyNum(.,big.mark=",", scientific=FALSE))) %>%
      plot_ly(.,x=~.$country, y=~.$avg,name="Comparison of Value",yaxis="Value",type='bar' )%>%
      layout(title="Average Values from 2000 to 2015",
             yaxis=list(title=paste("Average ", lookup$name[lookup$indicator_name==input$summary_indicator])),
             xaxis=list(title="Country")) 
  })
  
  output$world_map <- renderPlotly({
    # To do: modify this code to use an indicator code
    # selected using a selectInput element, in place of
    # the value "SP.DYN.CBRT.IN"
    # You might also try a different summarize function
    l <- list(color = toRGB("grey"), width = 0.5)
    g <- list(
      showframe = FALSE,
      showcoastlines = FALSE,
      projection = list(type = 'Mercator')
    )
    wb.df %>%
      filter(region != "Aggregates") %>%
      group_by(iso3c,country) %>%
      mutate_(chosen_ic=input$indicator_5) %>%
      summarize(avg=mean(chosen_ic, na.rm=TRUE)) %>%
      
    plot_geo()%>%
      add_trace(
        z=~avg, color=~avg,colors='Blues', text=~country,
        locations=~iso3c, locationmode='ISO-3',marker=list(line=l)
      )%>%
      colorbar(title='Indicator')%>%
      layout(
        title='World Map',geo=g
      )  
  })
  
  # Scatter Plot 
  output$scatter_plot <- renderPlotly({
    test1=group_by(wb.df, country,region) 
    test1=mutate_(test1,chosen_ic=input$indicator_4_1)
    test1=filter(test1,region != "Aggregates")
    test1=summarize(test1,avg=mean(chosen_ic, na.rm=TRUE))
    
    
    test2=group_by(wb.df, country, region) 
    test2=mutate_(test2,chosen_ic=input$indicator_4_2)
    test2=filter(test2,region != "Aggregates")
    test2=summarize(test2,avg=mean(chosen_ic, na.rm=TRUE))
    
    test3=group_by(wb.df, country, region) 
    test3=mutate_(test3,chosen_ic=input$indicator_4_3)
    test3=filter(test3,region != "Aggregates")
    test3=summarize(test3,avg=mean(chosen_ic, na.rm=TRUE))
    
    
    plot_ly(x=~test1$avg, y = ~test2$avg, text=~test1$country,size=test3$avg, color=test1$region)%>%
      layout(title="Scatter Plot",
             yaxis=list(title=paste("Average ", lookup$name[lookup$indicator_name==input$indicator_4_2])),
             xaxis=list(title=paste("Average ", lookup$name[lookup$indicator_name==input$indicator_4_1]))) 
  })
  
  
  output$line_plot <- renderPlotly({
    test1=group_by(wb.df, country) 
    test1=mutate_(test1,chosen_ic=input$indicator_3)
    test1=filter(test1,country==input$first_iso3c_3_1) 
    test1=summarize(group_by(test1,date),avg=mean(chosen_ic, na.rm=TRUE))
    
    test2=group_by(wb.df, country) 
    test2=mutate_(test2,chosen_ic=input$indicator_3)
    test2=filter(test2,country==input$first_iso3c_3_2) 
    test2=summarize(group_by(test2,date),avg=mean(chosen_ic, na.rm=TRUE))
    
    test3=group_by(wb.df, country) 
    test3=mutate_(test3,chosen_ic=input$indicator_3)
    test3=filter(test3,country==input$first_iso3c_3_3) 
    test3=summarize(group_by(test3,date),avg=mean(chosen_ic, na.rm=TRUE))
    
    
    plot_ly(test1,x=~date,y=~avg, name=input$first_iso3c_3_1,type='scatter',mode='lines',
            line = list(color = 'rgb(205, 12, 24)', width = 4)) %>%
      add_trace(y = ~test2$avg, name = input$first_iso3c_3_2, line = list(color = 'rgb(22, 96, 167)', width = 4)) %>%
      add_trace(y = ~test3$avg, name = input$first_iso3c_3_3, line = list(color = 'rgb(0,128,0)', width = 4)) %>%
      layout(title = "Change over time",
             xaxis = list(title = "Year"),
             yaxis = list (title = paste("Average ", lookup$name[lookup$indicator_name==input$indicator_3])))
    
  })
  
  output$heat_map <- renderPlotly({
    #wb.df=filter(wb.df,country==input$)
    z2=cbind(na.omit(wb.df$SP.POP.65UP.TO.ZS),na.omit(wb.df$SP.DYN.CBRT.IN),
             na.omit(wb.df$NY.GDP.MKTP.KD.ZG),na.omit(wb.df$SP.POP.DPND.OL),na.omit(wb.df$SH.XPD.PUBL.GX.ZS),
             na.omit(wb.df$SL.TLF.CACT.NE.ZS),na.omit(wb.df$NY.GDS.TOTL.ZS))
    plot_ly(z=z2,type="heatmap",colorscale = "colz",x=c("Pop 65+","Birth rate",
                                    "GDP Growth","Age Dependency ratio", "Health Expenditure",
                                    "Labor Force participation", "Domestic Savings"))
    
  })
  
}

#head(wb.df[indicator.codes])
shinyApp(ui, server)


