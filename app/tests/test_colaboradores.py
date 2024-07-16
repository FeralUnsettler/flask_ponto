import unittest
from app import app, db
from app.models import Colaborador

class ColaboradoresTestCase(unittest.TestCase):

    def setUp(self):
        app.config['TESTING'] = True
        app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'
        self.app = app.test_client()
        db.create_all()

    def tearDown(self):
        db.session.remove()
        db.drop_all()

    def test_lista_colaboradores(self):
        response = self.app.get('/colaboradores')
        self.assertEqual(response.status_code, 200)

    def test_novo_colaborador(self):
        response = self.app.post('/colaborador/novo', data=dict(
            cpf='12345678901',
            nome='Teste',
            data_nascimento='1990-01-01',
            data_admissao='2020-01-01',
            email='teste@example.com',
            telefone='999999999',
            usuario='teste',
            cargo='Desenvolvedor',
            funcao='Backend'
        ))
        self.assertEqual(response.status_code, 302)
        colaborador = Colaborador.query.filter_by(cpf='12345678901').first()
        self.assertIsNotNone(colaborador)

if __name__ == '__main__':
    unittest.main()
