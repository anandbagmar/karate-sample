import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.apache.commons.io.FileUtils;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class APITest {

    @BeforeClass
    public static void beforeClass() throws Exception {
        TestBase.beforeClass();
    }

    @Test
    public void testParallel() {
        String customTagsToRun = System.getenv("tag");

        Results results = null;
        if (customTagsToRun == null) {
            System.out.println("Run all tests");
            results = Runner.path("classpath:features").tags("~@ignore").parallel(5);
        } else {
            System.out.println("Run tests with tag - " + customTagsToRun);
            results = Runner.path("classpath:features").tags("~@ignore", customTagsToRun).parallel(5);
        }

        generateReport(results.getReportDir());
        Assert.assertTrue(results.getErrorMessages(), results.getFailCount() == 0);
    }


    public static void generateReport(String karateOutputPath) {
        System.out.println("================================");
        System.out.println("Generating reports");
        System.out.println("================================");
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[]{"json"}, true);
        List<String> jsonPaths = new ArrayList(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
        Configuration config = new Configuration(new File("target"), "demo");
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();
    }
}
