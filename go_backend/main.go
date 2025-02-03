package main

import (
	"log"
	"net/http"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

var db *gorm.DB
var err error

// User represents the model for a user
type User struct {
	ID       uint   `json:"id" gorm:"primaryKey"`
	Username string `json:"username"`
	Email    string `json:"email"`
	Password string `json:"password"`
	Avatar   string `json:"avatar"`
}

// Motivation represents the model for motivation
type Motivation struct {
	ID      uint   `json:"id" gorm:"primaryKey"`
	Content string `json:"content"`
}

// Todo represents the model for todo
type Todo struct {
	ID          uint   `json:"id" gorm:"primaryKey"`
	Title       string `json:"title"`
	Description string `json:"description"`
}

func main() {
	dsn := "root@tcp(127.0.0.1:3306)/vigenesia?charset=utf8mb4&parseTime=True&loc=Local"
	db, err = gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}

	db.AutoMigrate(&User{}, &Motivation{}, &Todo{})

	r := gin.Default()

	// Apply CORS middleware
	r.Use(cors.Default())

	r.POST("/register", register)
	r.POST("/login", login)
	r.PUT("/profile", updateProfile)

	r.GET("/motivations", getMotivations)
	r.POST("/motivations", createMotivation)
	r.PUT("/motivations/:id", updateMotivation)
	r.DELETE("/motivations/:id", deleteMotivation)

	r.GET("/todos", getTodos)
	r.POST("/todos", createTodo)
	r.PUT("/todos/:id", updateTodo)
	r.DELETE("/todos/:id", deleteTodo)

	r.Run(":8585")
}

func register(c *gin.Context) {
	var user User
	if err := c.ShouldBindJSON(&user); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user.Avatar = "assets/avatar/avatar1.jpg"
	db.Create(&user)
	c.JSON(http.StatusOK, user)
}

func login(c *gin.Context) {
	var user User
	if err := c.ShouldBindJSON(&user); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var foundUser User
	db.Where("email = ? AND password = ?", user.Email, user.Password).First(&foundUser)
	if foundUser.ID == 0 {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid email or password"})
		return
	}

	c.JSON(http.StatusOK, foundUser)
}

func updateProfile(c *gin.Context) {
	var updatedUser User
	if err := c.ShouldBindJSON(&updatedUser); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := db.Model(&User{}).Where("email = ?", updatedUser.Email).Updates(User{Username: updatedUser.Username, Avatar: updatedUser.Avatar}).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, updatedUser)
}

func getMotivations(c *gin.Context) {
	var motivations []Motivation
	db.Find(&motivations)
	c.JSON(http.StatusOK, motivations)
}

func createMotivation(c *gin.Context) {
	var motivation Motivation
	if err := c.ShouldBindJSON(&motivation); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	db.Create(&motivation)
	c.JSON(http.StatusOK, motivation)
}

func updateMotivation(c *gin.Context) {
	var motivation Motivation
	id := c.Param("id")
	if err := c.ShouldBindJSON(&motivation); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := db.Model(&Motivation{}).Where("id = ?", id).Updates(motivation).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, motivation)
}

func deleteMotivation(c *gin.Context) {
	id := c.Param("id")
	if err := db.Delete(&Motivation{}, id).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Motivation deleted"})
}

func getTodos(c *gin.Context) {
	var todos []Todo
	db.Find(&todos)
	c.JSON(http.StatusOK, todos)
}

func createTodo(c *gin.Context) {
	var todo Todo
	if err := c.ShouldBindJSON(&todo); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	db.Create(&todo)
	c.JSON(http.StatusOK, todo)
}

func updateTodo(c *gin.Context) {
	var todo Todo
	id := c.Param("id")
	if err := c.ShouldBindJSON(&todo); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := db.Model(&Todo{}).Where("id = ?", id).Updates(todo).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, todo)
}

func deleteTodo(c *gin.Context) {
	id := c.Param("id")
	if err := db.Delete(&Todo{}, id).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Todo deleted"})
}
