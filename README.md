# GameSphere-2000-App-Store-Insights-Ratings
Through data preprocessing in SQL and visualization techniques in Power BI, the project explores various aspects of these games, including distribution among age groups, user ratings, trends over time, and the impact of factors like game size and integration with Apple's Game Center. 

**Project Title: GameSphere 🕹️: 2000 App Store Insights & Ratings**

**Dataset Overview:**
The GameSphere dataset comprises 2000 entries, each representing a game from the App Store, spread across 14 columns. Most columns are fully populated, except for 'price' and 'releaseNotes' indicating potential missing data. Key columns include artistName, averageUserRating, contentAdvisoryRating, fileSizeBytes, isGameCenterEnabled, minimumOsVersion, price, releaseDate, trackName, and userRatingCount.

**Data Processing:**
The dataset underwent several preprocessing steps, including importing to MS SQL Server Management Studio 19 (SQL file added), removal of non-English characters (36 rows WHERE artistName LIKE '%[^ -~]%' COLLATE Latin1_General_BIN;), data type formatting, and date formatting to dd/mm/yyyy. Checks were performed to analyze the relationship between Game Center integration and user ratings, average user rating calculation verification, and bin creation for analyzing user ratings based on game size.


**Research Metrics:**

**Distribution of Games Among Age Groups:**
Age suitability ratings were enhanced for clarity (Added + sign for better understanding of content advisory raiting using AgeSuitabilityFormatted = 'GamesAppstore'[contentAdvisoryRating] & "+").<br>
Visualized as a treemap for intuitive exploration.<br>

**Distribution of Game Ratings Among Age Groups:**<br>
Visualized as a pie chart to highlight rating distribution.<br>

**Changes in Number of Games and Artists Over Time:**<br>
Utilized SQL date conversion and year extraction for temporal analysis:<br>
DateColumn = DATE(<br>
    VALUE(RIGHT(GamesAppstore[formatted_releaseDate], 4)),  -- Extract year<br>
    VALUE(MID(GamesAppstore[formatted_releaseDate], 4, 2)), -- Extract month<br>
    VALUE(LEFT(GamesAppstore[formatted_releaseDate], 2))    -- Extract day<br>
)<br>
Later Year was extracted using <br>
YearColumn = YEAR(DATEVALUE('GamesAppstore'[DateColumn<br>
Visualized as a ribbon chart for trend identification.<br>

**Games with Highest User Ratings:**<br>
Visualized as a stacked column chart to identify top-rated games.<br>

**Trend of Average User Ratings and Game Production Over Time:**<br>
Analyzed the trend of average user ratings and game production over time using a line chart.<br>

**Relationship Between Game File Size and User Engagement:**
Visualized as a stacked column chart with drill-down capability for detailed analysis.

**Impact of Game Center Integration on User Ratings:**
Visualized as a donut chart to assess if Game Center integration correlates with higher user ratings.

**Effect of Minimum OS Version on User Engagement:**
Created bins for minimum OS version and visualized as a stacked column chart to understand its impact on user engagement.
