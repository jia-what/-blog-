<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" isELIgnored="false" %>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>运维工程师简历 - heber</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        :root {
            --primary: #2c3e50;
            --secondary: #3498db;
            --accent: #27ae60;
            --light: #ecf0f1;
            --dark: #34495e;
            --gray: #95a5a6;
        }

        body {
            background-color: #f5f7fa;
            color: #333;
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            padding: 40px 0;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        header::before {
            content: "";
            position: absolute;
            top: -50px;
            left: -50px;
            width: 200px;
            height: 200px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }

        header::after {
            content: "";
            position: absolute;
            bottom: -80px;
            right: -80px;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }

        .profile {
            position: relative;
            z-index: 2;
        }

        .profile-img {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            border: 5px solid rgba(255, 255, 255, 0.3);
            margin: 0 auto 20px;
            background-color: #fff;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .profile-img i {
            font-size: 5rem;
            color: var(--secondary);
        }

        .name {
            font-size: 2.5rem;
            margin-bottom: 10px;
            font-weight: 700;
        }

        .title {
            font-size: 1.2rem;
            opacity: 0.9;
            margin-bottom: 20px;
        }

        .contact-info {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 20px;
            margin-top: 20px;
        }

        .contact-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .contact-item i {
            font-size: 1.2rem;
        }

        .resume-content {
            display: flex;
            flex-wrap: wrap;
            gap: 30px;
            margin: 40px 0;
        }

        .left-column {
            flex: 1;
            min-width: 300px;
        }

        .right-column {
            flex: 2;
            min-width: 300px;
        }

        .card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            padding: 25px;
            margin-bottom: 30px;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }

        .section-title {
            color: var(--accent);
            font-size: 1.5rem;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--light);
            position: relative;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title::after {
            content: "";
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 50px;
            height: 2px;
            background: var(--accent);
        }

        .about-text {
            text-align: justify;
        }

        .skills-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 15px;
        }

        .skill-item {
            background: var(--light);
            padding: 10px 15px;
            border-radius: 5px;
            text-align: center;
            font-weight: 500;
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .skill-item i {
            color: var(--accent);
        }

        .timeline {
            position: relative;
            padding-left: 30px;
        }

        .timeline::before {
            content: "";
            position: absolute;
            left: 5px;
            top: 0;
            height: 100%;
            width: 2px;
            background: var(--light);
        }

        .timeline-item {
            position: relative;
            margin-bottom: 30px;
        }

        .timeline-item:last-child {
            margin-bottom: 0;
        }

        .timeline-item::before {
            content: "";
            position: absolute;
            left: -29px;
            top: 5px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: var(--accent);
            border: 2px solid white;
            z-index: 2;
        }

        .timeline-date {
            color: var(--gray);
            font-size: 0.9rem;
            margin-bottom: 5px;
        }

        .timeline-title {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--primary);
        }

        .timeline-subtitle {
            color: var(--secondary);
            font-weight: 500;
            margin-bottom: 10px;
        }

        .projects-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }

        .project-card {
            border: 1px solid var(--light);
            border-radius: 8px;
            overflow: hidden;
            transition: transform 0.3s;
        }

        .project-card:hover {
            transform: translateY(-5px);
        }

        .project-img {
            height: 180px;
            background: linear-gradient(45deg, var(--primary), var(--accent));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2rem;
        }

        .project-content {
            padding: 20px;
        }

        .project-title {
            font-size: 1.2rem;
            margin-bottom: 10px;
            color: var(--primary);
        }

        .project-desc {
            color: var(--gray);
            margin-bottom: 15px;
        }

        .project-tech {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .tech-tag {
            background: var(--light);
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
        }

        .infra-diagram {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-top: 20px;
            text-align: center;
        }

        .server {
            display: inline-block;
            width: 80px;
            height: 100px;
            background: linear-gradient(to bottom, #e0e0e0, #bdbdbd);
            border-radius: 8px;
            margin: 0 15px;
            position: relative;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        .server::before {
            content: "";
            position: absolute;
            top: 10px;
            left: 10px;
            width: 60px;
            height: 10px;
            background: #4CAF50;
            border-radius: 5px;
        }

        .server::after {
            content: "";
            position: absolute;
            bottom: 10px;
            left: 10px;
            width: 60px;
            height: 5px;
            background: #2196F3;
            border-radius: 3px;
        }

        .network-line {
            display: inline-block;
            width: 50px;
            height: 2px;
            background: #3498db;
            vertical-align: middle;
        }

        .network-node {
            display: inline-block;
            width: 20px;
            height: 20px;
            background: #3498db;
            border-radius: 50%;
            vertical-align: middle;
        }

        footer {
            background: var(--primary);
            color: white;
            text-align: center;
            padding: 20px;
            margin-top: 50px;
        }

        .social-links {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 15px;
        }

        .social-links a {
            color: white;
            font-size: 1.5rem;
            transition: transform 0.3s;
        }

        .social-links a:hover {
            transform: translateY(-5px);
            color: var(--secondary);
        }

        @media (max-width: 768px) {
            .resume-content {
                flex-direction: column;
            }
            
            .contact-info {
                flex-direction: column;
                align-items: center;
                gap: 10px;
            }
            
            .name {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <header>
        <div class="profile">
            <div class="profile-img">
                <i class="fas fa-server"></i>
            </div>
            <h1 class="name">heber</h1>
            <p class="title">高级运维工程师 | 云架构师</p>
            <div class="contact-info">
                <div class="contact-item">
                    <i class="fas fa-envelope"></i>
                    <span>heber@example.com</span>
                </div>
                <div class="contact-item">
                    <i class="fas fa-phone"></i>
                    <span>139-8888-8888</span>
                </div>
                <div class="contact-item">
                    <i class="fas fa-map-marker-alt"></i>
                    <span>上海</span>
                </div>
            </div>
        </div>
    </header>

    <div class="container">
        <div class="resume-content">
            <div class="left-column">
                <div class="card">
                    <h2 class="section-title"><i class="fas fa-user"></i>关于我</h2>
                    <p class="about-text">
                        拥有8年运维经验的高级工程师，专注于构建高可用、可扩展的IT基础设施。精通云平台架构设计、自动化运维和系统优化。成功管理过多个大型分布式系统，具备出色的故障排查和问题解决能力。致力于通过技术提升系统稳定性和运维效率。
                    </p>
                </div>

                <div class="card">
                    <h2 class="section-title"><i class="fas fa-tools"></i>专业技能</h2>
                    <div class="skills-container">
                        <div class="skill-item"><i class="fab fa-linux"></i> Linux系统管理</div>
                        <div class="skill-item"><i class="fas fa-cloud"></i> AWS/Azure</div>
                        <div class="skill-item"><i class="fab fa-docker"></i> Docker/K8s</div>
                        <div class="skill-item"><i class="fas fa-code"></i> Ansible/Terraform</div>
                        <div class="skill-item"><i class="fas fa-network-wired"></i> 网络管理</div>
                        <div class="skill-item"><i class="fas fa-shield-alt"></i> 系统安全</div>
                        <div class="skill-item"><i class="fas fa-database"></i> MySQL/Redis</div>
                        <div class="skill-item"><i class="fas fa-chart-line"></i> 监控与告警</div>
                        <div class="skill-item"><i class="fas fa-terminal"></i> Shell/Python</div>
                        <div class="skill-item"><i class="fas fa-sync-alt"></i> CI/CD流水线</div>
                    </div>
                </div>

                <div class="card">
                    <h2 class="section-title"><i class="fas fa-certificate"></i>证书</h2>
                    <div class="skills-container">
                        <div class="skill-item"><i class="fab fa-aws"></i> AWS解决方案架构师</div>
                        <div class="skill-item"><i class="fas fa-certificate"></i> CKA认证</div>
                        <div class="skill-item"><i class="fas fa-certificate"></i> RHCE认证</div>
                        <div class="skill-item"><i class="fas fa-certificate"></i> CCNA认证</div>
                    </div>
                </div>

                <div class="card">
                    <h2 class="section-title"><i class="fas fa-graduation-cap"></i>教育背景</h2>
                    <div class="timeline">
                        <div class="timeline-item">
                            <div class="timeline-date">2010 - 2014</div>
                            <h3 class="timeline-title">上海交通大学</h3>
                            <p class="timeline-subtitle">计算机科学与技术 | 本科</p>
                            <p>主修课程：计算机网络、操作系统、分布式系统、数据库原理</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="right-column">
                <div class="card">
                    <h2 class="section-title"><i class="fas fa-briefcase"></i>工作经历</h2>
                    <div class="timeline">
                        <div class="timeline-item">
                            <div class="timeline-date">2019 - 至今</div>
                            <h3 class="timeline-title">云科技股份有限公司</h3>
                            <p class="timeline-subtitle">高级运维工程师</p>
                            <ul>
                                <li>负责公司混合云架构的设计与实施，管理超过500台服务器</li>
                                <li>建立自动化运维体系，使用Ansible实现95%的配置自动化</li>
                                <li>设计并实施Kubernetes集群，支持微服务架构的部署</li>
                                <li>优化监控系统，将故障响应时间缩短60%</li>
                                <li>制定灾难恢复计划，确保系统RTO小于30分钟</li>
                            </ul>
                        </div>
                        
                        <div class="timeline-item">
                            <div class="timeline-date">2016 - 2019</div>
                            <h3 class="timeline-title">数据技术有限公司</h3>
                            <p class="timeline-subtitle">系统运维工程师</p>
                            <ul>
                                <li>管理公司数据中心基础设施，确保99.99%的可用性</li>
                                <li>实施Zabbix监控系统，覆盖所有关键业务指标</li>
                                <li>设计并部署ELK日志分析平台，提升故障排查效率</li>
                                <li>负责系统安全加固，通过ISO27001认证</li>
                                <li>建立CI/CD流水线，实现自动化部署</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <h2 class="section-title"><i class="fas fa-project-diagram"></i>项目经验</h2>
                    <div class="projects-grid">
                        <div class="project-card">
                            <div class="project-img">
                                <i class="fas fa-cloud"></i>
                            </div>
                            <div class="project-content">
                                <h3 class="project-title">混合云迁移项目</h3>
                                <p class="project-desc">将本地数据中心迁移到AWS和Azure混合云环境</p>
                                <div class="project-tech">
                                    <span class="tech-tag">AWS</span>
                                    <span class="tech-tag">Azure</span>
                                    <span class="tech-tag">Terraform</span>
                                </div>
                            </div>
                        </div>
                        
                        <div class="project-card">
                            <div class="project-img">
                                <i class="fab fa-docker"></i>
                            </div>
                            <div class="project-content">
                                <h3 class="project-title">K8s集群部署</h3>
                                <p class="project-desc">设计并部署高可用Kubernetes集群，支持微服务架构</p>
                                <div class="project-tech">
                                    <span class="tech-tag">Kubernetes</span>
                                    <span class="tech-tag">Helm</span>
                                    <span class="tech-tag">Prometheus</span>
                                </div>
                            </div>
                        </div>
                        
                        <div class="project-card">
                            <div class="project-img">
                                <i class="fas fa-bolt"></i>
                            </div>
                            <div class="project-content">
                                <h3 class="project-title">自动化运维平台</h3>
                                <p class="project-desc">开发基于Ansible的自动化运维平台，减少人工操作</p>
                                <div class="project-tech">
                                    <span class="tech-tag">Ansible</span>
                                    <span class="tech-tag">Python</span>
                                    <span class="tech-tag">Django</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <h2 class="section-title"><i class="fas fa-network-wired"></i>基础设施架构</h2>
                    <div class="infra-diagram">
                        <div class="server"><i class="fas fa-fire" style="position:absolute; top:40px; left:30px; color:#e74c3c;"></i></div>
                        <div class="network-node"></div>
                        <div class="network-line"></div>
                        <div class="network-node"></div>
                        <div class="network-line"></div>
                        <div class="server"><i class="fas fa-database" style="position:absolute; top:40px; left:30px; color:#3498db;"></i></div>
                        <div class="network-line"></div>
                        <div class="network-node"></div>
                        <div class="network-line"></div>
                        <div class="server"><i class="fab fa-aws" style="position:absolute; top:40px; left:30px; color:#FF9900;"></i></div>
                        <p style="margin-top: 20px; color: var(--gray);">高可用混合云架构示意图</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <footer>
        <p>© 2023 heber - 运维工程师简历</p>
        <div class="social-links">
            <a href="#"><i class="fab fa-github"></i></a>
            <a href="#"><i class="fab fa-linkedin-in"></i></a>
            <a href="#"><i class="fab fa-weixin"></i></a>
            <a href="#"><i class="fab fa-stack-overflow"></i></a>
        </div>
    </footer>
</body>
</html>