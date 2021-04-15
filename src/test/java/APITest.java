import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import net.masterthought.cucumber.presentation.PresentationMode;
import org.apache.commons.io.FileUtils;
import org.junit.*;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class APITest {
    Results results = null;

    @BeforeClass
    public static void beforeClass() throws Exception {
        TestBase.beforeClass();
        System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
        System.out.println("APITest: Before Class");
        System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    }

    @AfterClass
    public static void afterClass() throws Exception {
        TestBase.afterClass();
        System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
        System.out.println("APITest: After Class");
        System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    }

    @Test
    public void testParallel() {
        String parallel = System.getProperty("parallel");
        int parallelCount = (null == parallel) ? 30 : Integer.parseInt(parallel);
        System.out.println("Parallel count: " + parallelCount);

        String customTagsToRun = System.getProperty("tag");
        List<String> strings = new ArrayList<>();
        strings.add("~@ignore");
        strings.add("~@wip");
        strings.add("~@template");
        if ((null != customTagsToRun) && (!customTagsToRun.trim().isEmpty())) { strings.add(customTagsToRun); }
        System.out.println("Run tests with tag - " + strings);
        results = Runner.path("classpath:features").tags(strings).outputCucumberJson(true).reportDir("reports/surefire-reports").parallel(parallelCount);
    }

    @After
    public void afterMethod() {
        System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
        System.out.println("APITest: After Method");

        String reportLocation = generateReport(results.getReportDir());
        System.out.println("Reports available here: " + reportLocation);
        System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
        Assert.assertTrue(results.getErrorMessages(), results.getFailCount() == 0);
    }

    public static void main(String[] args) {
        String reportLocation = generateReport("reports/surefire-reports");
        System.out.println("Reports available here: " + reportLocation);
    }

    private static String generateReport(String karateOutputPath) {
        System.out.println("================================");
        System.out.println("Generating reports");
        System.out.println("================================");
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[]{"json"}, true);
        System.out.println("Number of json files found: " + jsonFiles.size());
        List<String> jsonPaths = new ArrayList(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
        Configuration config = new Configuration(new File("reports"), "karate-sample");
        config.addPresentationModes(PresentationMode.RUN_WITH_JENKINS);
        jsonPaths.forEach(filePath -> {
            String qual = filePath.replaceAll(".*/surefire-reports/", "").replaceAll(".json", "");
            System.out.println(filePath);
            System.out.println(qual);
            config.setQualifier(filePath, qual);
        });
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();
        return config.getReportDirectory().getAbsolutePath() + "/cucumber-html-reports/overview-features.html";
    }
}
