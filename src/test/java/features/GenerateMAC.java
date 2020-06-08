package features;

import net.minidev.json.JSONObject;
import org.apache.commons.codec.binary.Base64;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

public class GenerateMAC {
    public String generate(String uuid, String mobileNumber, String randomNumber, Object requestBody) {
        String key = uuid + mobileNumber + randomNumber;
        System.out.println("key: " + key);
        System.out.println("requestBody: " + requestBody);
        try {
            String hmacSHA256 = "HmacSHA256";
            Mac mac = Mac.getInstance(hmacSHA256);
            SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(), hmacSHA256);
            mac.init(secretKey);
            String hashData = Base64.encodeBase64String(mac.doFinal(requestBody.toString().getBytes()));
            System.out.println((hashData));
            return hashData;
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
    }
}