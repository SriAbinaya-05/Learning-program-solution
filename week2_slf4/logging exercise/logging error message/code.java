public class LoggingExample {
    private static final Logger logger = LoggerFactory.getLogger(LoggingExample.class);

    public static void main(String[] args) {
        logger.error("This is an error message");
        logger.warn("This is a warning message");
    }
}

class Logger {
    private String className;

    public Logger(String className) {
        this.className = className;
    }

    public void error(String message) {
        System.out.println("[ERROR] [" + className + "] " + message);
    }

    public void warn(String message) {
        System.out.println("[WARN]  [" + className + "] " + message);
    }
}

class LoggerFactory {
    public static Logger getLogger(Class<?> clazz) {
        return new Logger(clazz.getSimpleName());
    }
}
