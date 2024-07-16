from flask import render_template, request, redirect, url_for, flash
from . import app, db
from .models import Colaborador, Horario

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/colaboradores')
def lista_colaboradores():
    colaboradores = Colaborador.query.all()
    return render_template('colaboradores.html', colaboradores=colaboradores)

@app.route('/colaborador/novo', methods=['GET', 'POST'])
def novo_colaborador():
    if request.method == 'POST':
        # Processa o formulário de criação de colaborador
        pass
    return render_template('cadastro_colaborador.html')

@app.route('/colaborador/<int:id>/editar', methods=['GET', 'POST'])
def editar_colaborador(id):
    colaborador = Colaborador.query.get_or_404(id)
    if request.method == 'POST':
        # Processa o formulário de edição de colaborador
        pass
    return render_template('alterar_colaborador.html', colaborador=colaborador)

@app.route('/colaborador/<int:id>/excluir', methods=['POST'])
def excluir_colaborador(id):
    colaborador = Colaborador.query.get_or_404(id)
    db.session.delete(colaborador)
    db.session.commit()
    return redirect(url_for('lista_colaboradores'))

@app.route('/registro_ponto')
def registro_ponto():
    return render_template('registro_ponto.html')
