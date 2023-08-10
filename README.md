# Task-3-UQMetric
The UQ metrics are categorized in three parts: single time series, ensemble member, and multiple time series. 
- For temporal uncertainty, we consider moving-window based metrics instead of point to point metrics. These metrics reflect the informativeness of the given data.
- For spatial uncertainty, we quantify the uncertainty from wind farm turbine layout. The uncertainty among turbines is converted to a function between uncertainty and distance. 
- For ensemble members, we quantify uncertainty from multiple ensemble data sources.
  
UQ metric is summarized as follows:
<table>
    <thead>
        <tr>
            <th>   </th>
            <th>Type of Metric</th>
            <th>Metric</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
                <tr>
            <td rowspan=9>Temporal Uncertainty</td>
            <td rowspan=8>Moving-window</td>
            <td>Entropy</td>
            <td>Quantify the uncertainty based on information in the given moving window</td>
        </tr>
        <tr>
            <td>Standard Deviation</td>
            <td>Measure the amount of variation among the given moving window</td>
        </tr>
        <tr>
            <td>Turbulence Intensity</td>
            <td>Measure the intensity of wind velocity fluctuation in the given moving window</td>
        </tr>
        <tr>
            <td>Variability Index</td>
            <td>Measure the standardized maximum difference in the given moving window</td>
        </tr>
        <tr>
            <td>Correlation</td>
            <td>Linear correlation between one data source and the actual</td>
        </tr>
        <tr> 
            <td>MAPE</td>
            <td>The average deviation between one data source and the actual</td>
        </tr>
        <tr>
            <td>nRMSE</td>
            <td>The average weighted performance between one data source and the actual</td>
        </tr>
        <tr>
            <td>nMAE</td>
            <td>The average difference between one data source and the actual</td>
        </tr>
        <tr>
        <tr>
            <td rowspan=3>Spatial Uncertainty</td>
            <td rowspan=3>Spatial</td>
            <td>Nugget</td>
            <td>Quantify small-scale spatial variations within the fields</td>
        </tr>
        <tr>
            <td>Sill</td>
            <td>Measure the magnitude of variation</td>
        </tr>
        <tr>
            <td>Range</td>
            <td>The distance beyong which observations are no longer spatially correlated</td>
        </tr>
        <tr>
            <td rowspan=4>Data Source Uncertainty</td>
            <td rowspan=2>Moving-window</td>
            <td>Correlation</td>
            <td>Linear correlation between multiple data sources and the actual</td>
        </tr>
        <tr>
            <td>MAPE</td>
            <td>The average deviation between multiple data sources and the actual</td>
        </tr>
        <tr>
            <td rowspan=2>Distribution</td>
            <td>Spread Index</td>
            <td>The maximum difference between multiple data sources and the actual</td>
        </tr>
        <tr>
            <td>Predictability Index</td>
            <td>Identify multiple data sources with above or below average uncertainty</td>
        </tr>
    </tbody>
</table>
