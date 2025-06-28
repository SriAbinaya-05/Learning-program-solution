interface ExternalApi {
    String getData();
}


class MockExternalApi implements ExternalApi {
    @Override
    public String getData() {
        return "Mock Data"; 
    }
}
class MyService {
    private ExternalApi api;

    public MyService(ExternalApi api) {
        this.api = api;
    }

    public String fetchData() {
        return api.getData();
    }
}

public class Main {
    public static void main(String[] args) {
        ExternalApi mockApi = new MockExternalApi();
        MyService service = new MyService(mockApi);
        String result = service.fetchData();
         if ("Mock Data".equals(result)) {
            System.out.println("Test PASSED");
        } else {
            System.out.println("Test FAILED: Expected 'Mock Data', but got '" + result + "'");
        }
    }
}
