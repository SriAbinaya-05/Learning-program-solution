interface ExternalApi {
    String getData();
}
class MockExternalApi implements ExternalApi {
    boolean wasGetDataCalled = false;

    @Override
    public String getData() {
        wasGetDataCalled = true;
        return "Mock Data";
    }

    public boolean wasMethodCalled() {
        return wasGetDataCalled;
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

        MockExternalApi mockApi = new MockExternalApi();

        MyService service = new MyService(mockApi);
        service.fetchData();
        if (mockApi.wasMethodCalled()) {
            System.out.println("Test PASSED: getData() was called");
        } else {
            System.out.println("Test FAILED: getData() was NOT called");
        }
    }
}
