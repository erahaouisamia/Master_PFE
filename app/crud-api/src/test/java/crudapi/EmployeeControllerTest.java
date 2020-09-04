package crudapi;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;

import org.junit.jupiter.api.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import crudapi.Employee;
import crudapi.Springboot2JpaCrudExampleApplication;

@SpringBootApplication(exclude = {
  DataSourceAutoConfiguration.class
})
@RunWith(SpringRunner.class)
@SpringBootTest(classes = Springboot2JpaCrudExampleApplication.class)
@AutoConfigureMockMvc
public class EmployeeControllerTest {
	//@Autowired
	//private EmployeeController empCont;
	@Autowired
    private MockMvc mvc;

	//@MockBean
	//private EmployeeRepository repository;
	
	private String ObjToJson(Object obj) throws JsonProcessingException {
		ObjectMapper objectMapper = new ObjectMapper();
	    return objectMapper.writeValueAsString(obj);
	}
	private <T> T ObjFromJson(String json, Class<T> classe) throws JsonMappingException, JsonProcessingException {
		ObjectMapper objectMapper = new ObjectMapper();
		return objectMapper.readValue(json, classe);
	}
	@Test
	public void contextLoads() {
	 }
	@Test
	public void getAllEmployeesTest() throws Exception {
		 MvcResult mvcResult = mvc.perform(get("/api/v1/employees")
			      .accept(MediaType.APPLICATION_JSON_VALUE)).andReturn();
			   
		int status = mvcResult.getResponse().getStatus();
		assertEquals(200, status, "Not working");
		String content = mvcResult.getResponse().getContentAsString();
		Employee[] emplist = ObjFromJson(content,Employee[].class);
		assertTrue(emplist.length > 0, "BD vide");
	}
	
	@Test
	public void getEmployeeByIdTest() throws Exception {
		Long id = new Long(4);
		MvcResult mvcResult = mvc.perform(get("/api/v1/employees/{id}",id)
			      .accept(MediaType.APPLICATION_JSON_VALUE)).andReturn();
			   
		int status = mvcResult.getResponse().getStatus();
		assertEquals(200, status,"Not working");
		String content = mvcResult.getResponse().getContentAsString();
		Employee emp = ObjFromJson(content,Employee.class);
		assertNotNull(emp, "Not working");
	}
	
	@Test
	public void saveEmployeeTest() throws Exception {
		Employee e1 = new Employee("test1", "TEST1", "test1@gmail.com");
		//when(repository.save(e1)).thenReturn(e1);
		//assertEquals(e1, empCont.createEmployee(e1));
		String jsonStr = ObjToJson(e1);
		MvcResult mvcResult = mvc.perform(post("/api/v1/employees/")
				.contentType(MediaType.APPLICATION_JSON_VALUE)
				.content(jsonStr)).andReturn();
		int status = mvcResult.getResponse().getStatus();
		assertEquals(200, status,  "Not working");
		String content = mvcResult.getResponse().getContentAsString();
		Employee emp = ObjFromJson(content,Employee.class);
		assertEquals(e1.getLastName(), emp.getLastName(), "Employee not saved");
	}
	
	@Test
	public void updateEmployeeTest() throws Exception {
		Long id = new Long(4);
		Employee e1 = new Employee("Samia", "ER", "samiaerahaoui@gmail.com");
		e1.setLastName("ERAHAOUI");
		String jsonStr = ObjToJson(e1);
		MvcResult mvcResult = mvc.perform(put("/api/v1/employees/{id}",id)
				.contentType(MediaType.APPLICATION_JSON_VALUE)
				.content(jsonStr)).andReturn();
		int status = mvcResult.getResponse().getStatus();
		assertEquals(200, status,"Not working");
		String content = mvcResult.getResponse().getContentAsString();
		Employee emp = ObjFromJson(content,Employee.class);
		assertEquals(emp.getLastName(),e1.getLastName(), "Employee not updated");
	}
	
	@Test
	public void deleteEmployeeTest() throws Exception {
		Long id = new Long(14);
	    MvcResult mvcResult = mvc.perform(delete("/api/v1/employees/{id}",id)).andReturn();
	    int status = mvcResult.getResponse().getStatus();
	    assertEquals(200, status,"Not working");
	    String content = mvcResult.getResponse().getContentAsString();
	    assertEquals(content, "{\"deleted\":true}", "Not deleted");
	   }

}
