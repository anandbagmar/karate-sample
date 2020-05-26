import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
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
        String customTagsToRun = System.getenv("tag");

        if (customTagsToRun == null) {
            System.out.println("Run all tests");
            results = Runner.path("classpath:features").tags("~@ignore").reportDir("reports/surefire-reports").parallel(10);
        } else {
            System.out.println("Run tests with tag - " + customTagsToRun);
            results = Runner.path("classpath:features").tags("~@ignore", customTagsToRun).reportDir("reports/surefire-reports").parallel(10);
        }
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

    private static String generateReport(String karateOutputPath) {
        System.out.println("================================");
        System.out.println("Generating reports");
        System.out.println("================================");
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[]{"json"}, true);
        List<String> jsonPaths = new ArrayList(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
        Configuration config = new Configuration(new File("reports"), "karate-sample");
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();
        return config.getReportDirectory().getAbsolutePath() + "/cucumber-html-reports/overview-features.html";
    }
}
