from flask import Blueprint, render_template, redirect, url_for, request, flash
from .models import db, Colaborador
from .forms import ColaboradorForm

bp = Blueprint('routes', __name__)

@bp.route('/')
def index():
    return render_template('index.html')

@bp.route('/registro_ponto')
def registro_ponto():
    return render_template('registro_ponto.html')

@bp.route('/colaboradores')
def lista_colaboradores():
    colaboradores = Colaborador.query.all()
    return render_template('lista_colaboradores.html', colaboradores=colaboradores)

@bp.route('/colaboradores/novo', methods=['GET', 'POST'])
def cadastro_colaborador():
    form = ColaboradorForm()
    if form.validate_on_submit():
        # Adiciona o novo colaborador ao banco de dados
        novo_colaborador = Colaborador(
            cpf=form.cpf.data,
            nome=form.nome.data,
            email=form.email.data,
            telefone=form.telefone.data,
            data_admissao=form.data_admissao.data,
            cargo=form.cargo.data,
            funcao=form.funcao.data,
            usuario=form.usuario.data,
        )
        db.session.add(novo_colaborador)
        db.session.commit()
        flash('Colaborador cadastrado com sucesso!', 'success')
        return redirect(url_for('routes.lista_colaboradores'))
    return render_template('cadastro_colaborador.html', form=form)

@bp.route('/colaboradores/<int:id>/editar', methods=['GET', 'POST'])
def alterar_colaborador(id):
    colaborador = Colaborador.query.get_or_404(id)
    form = ColaboradorForm(obj=colaborador)
    if form.validate_on_submit():
        form.populate_obj(colaborador)
        db.session.commit()
        flash('Colaborador atualizado com sucesso!', 'success')
        return redirect(url_for('routes.lista_colaboradores'))
    return render_template('alterar_colaborador.html', form=form)

@bp.route('/colaboradores/<int:id>/excluir', methods=['POST'])
def excluir_colaborador(id):
    colaborador = Colaborador.query.get_or_404(id)
    db.session.delete(colaborador)
    db.session.commit()
    flash('Colaborador excluído com sucesso!', 'success')
    return redirect(url_for('routes.lista_colaboradores'))
