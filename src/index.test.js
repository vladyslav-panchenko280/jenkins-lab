const request = require('supertest');
const app = require('./index');

describe('API Tests', () => {
  describe('GET /', () => {
    it('should return welcome message', async () => {
      const res = await request(app)
        .get('/')
        .expect(200);
      
      expect(res.body).toHaveProperty('message');
      expect(res.body.message).toBe('Welcome to the API');
    });
  });

  describe('GET /health', () => {
    it('should return health status', async () => {
      const res = await request(app)
        .get('/health')
        .expect(200);
      
      expect(res.body).toHaveProperty('status');
      expect(res.body.status).toBe('ok');
      expect(res.body).toHaveProperty('timestamp');
    });
  });

  describe('GET /api/users', () => {
    it('should return list of users', async () => {
      const res = await request(app)
        .get('/api/users')
        .expect(200);
      
      expect(res.body).toHaveProperty('users');
      expect(Array.isArray(res.body.users)).toBe(true);
      expect(res.body.users.length).toBeGreaterThan(0);
    });
  });

  describe('GET /api/users/:id', () => {
    it('should return a specific user', async () => {
      const res = await request(app)
        .get('/api/users/1')
        .expect(200);
      
      expect(res.body).toHaveProperty('user');
      expect(res.body.user).toHaveProperty('id');
      expect(res.body.user).toHaveProperty('name');
      expect(res.body.user).toHaveProperty('email');
    });

    it('should return 404 for non-existent user', async () => {
      const res = await request(app)
        .get('/api/users/999')
        .expect(404);
      
      expect(res.body).toHaveProperty('error');
      expect(res.body.error).toBe('User not found');
    });
  });

  describe('POST /api/users', () => {
    it('should create a new user', async () => {
      const newUser = {
        name: 'Test User',
        email: 'test@example.com'
      };
      
      const res = await request(app)
        .post('/api/users')
        .send(newUser)
        .expect(201);
      
      expect(res.body).toHaveProperty('user');
      expect(res.body.user).toHaveProperty('id');
      expect(res.body.user.name).toBe(newUser.name);
      expect(res.body.user.email).toBe(newUser.email);
    });

    it('should return 400 if name is missing', async () => {
      const res = await request(app)
        .post('/api/users')
        .send({ email: 'test@example.com' })
        .expect(400);
      
      expect(res.body).toHaveProperty('error');
      expect(res.body.error).toBe('Name and email are required');
    });

    it('should return 400 if email is missing', async () => {
      const res = await request(app)
        .post('/api/users')
        .send({ name: 'Test User' })
        .expect(400);
      
      expect(res.body).toHaveProperty('error');
      expect(res.body.error).toBe('Name and email are required');
    });
  });

  describe('404 Handler', () => {
    it('should return 404 for unknown routes', async () => {
      const res = await request(app)
        .get('/unknown/route')
        .expect(404);
      
      expect(res.body).toHaveProperty('error');
      expect(res.body.error).toBe('Route not found');
    });
  });
});

