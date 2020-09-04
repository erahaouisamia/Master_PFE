package crudapi;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(exclude = {
  DataSourceAutoConfiguration.class
})
public class Springboot2JpaCrudExampleApplication {

	public static void main(String[] args) {
		SpringApplication.run(Springboot2JpaCrudExampleApplication.class, args);
	}

}
